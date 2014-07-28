#include "stdafx.h"
#include "gpp/game.h"

#include "gep/globalManager.h"
#include "gep/exception.h"
#include "gep/cameras.h"
#include "gep/utils.h"

#include "gep/interfaces/logging.h"
#include "gep/interfaces/physics.h"
#include "gep/interfaces/renderer.h"
#include "gep/interfaces/scripting.h"
#include "gep/interfaces/inputHandler.h"
#include "gep/interfaces/sound.h"

#include "gep/math3d/vec3.h"
#include "gep/math3d/color.h"

#include "gpp/gameObjectSystem.h"

#include "gep/interfaces/cameraManager.h"

#include "gpp/stateMachines/state.h"
#include "gpp/stateMachines/stateMachine.h"
#include "gpp/stateMachines/stateMachineFactory.h"

#include "gep/memory/leakDetection.h"

#include "gpp/gameComponents/cameraComponent.h"

namespace
{
    gep::MallocAllocator g_mallocAllocator;
}

using namespace gep;

gpp::Game::Game() :
    m_pStateMachineFactory(nullptr),
    m_pDummyCam(nullptr),
    m_pStateMachine(nullptr),
    m_continueRunningGame(false)
{
}

gpp::Game::~Game()
{
    m_pDummyCam = nullptr;
    // TODO: m_pStateMachine should be a gep::SmartPtr!
    m_pStateMachine = nullptr;
}

void gpp::Game::initialize()
{
    m_continueRunningGame = true;

    // register render callback
    g_globalManager.getRendererExtractor()->registerExtractionCallback(std::bind(&Game::render, this, std::placeholders::_1));
    m_pDummyCam = new FreeCameraHorizon();
    m_pDummyCam->setViewAngle(60.0f);
    g_globalManager.getCameraManager()->setActiveCamera(m_pDummyCam);

    m_pStateMachineFactory = GEP_NEW(g_stdAllocator, sm::StateMachineFactory)(&g_stdAllocator);
    m_pStateMachineFactory->initialize();

    m_pStateMachine = m_pStateMachineFactory->create("game");
    setUpStateMachine();

    // Scripting related initialization
    //////////////////////////////////////////////////////////////////////////

    auto scripting = g_globalManager.getScriptingManager();

    makeScriptBindings();
	auto L = scripting->getState();
	lua_pushlightuserdata(L, nullptr);
	lua_setglobal(L, "null");

    {
        // setup.lua
        scripting->loadScript("setup.lua", IScriptingManager::LoadOptions::IsImportantScript);

        // initialize.lua
        scripting->setManagerState(IScriptingManager::State::AcceptingScriptRegistration);
        SCOPE_EXIT { scripting->setManagerState(IScriptingManager::State::NotAcceptingScriptRegistration); });

        scripting->loadScript("initialize.lua", IScriptingManager::LoadOptions::IsImportantScript);
    }

    try
    {
        g_globalManager.getScriptingManager()->loadAllRegisteredScripts();
    }
    catch (ScriptLoadException&)
    {
        auto message = "An error occurred loading one of the registered scripts. Check the log.";
        GEP_ASSERT(false, message);
        g_globalManager.getLogging()->logError(message);
    }
    catch (ScriptExecutionException&)
    {
        auto message = "An error occurred executing one of the registered scripts. Check the log.";
        GEP_ASSERT(false, message);
        g_globalManager.getLogging()->logError(message);
    }

    auto pPhysicsWorld = g_globalManager.getPhysicsSystem()->getWorld();
    GEP_ASSERT(pPhysicsWorld, "You need to create a proper physics world!");
    gep::IWorld::ScopedLock physicsWorldLock(pPhysicsWorld);

    m_pStateMachine->run();
    g_gameObjectManager.initialize();
}

void gpp::Game::destroy()
{
    m_pStateMachineFactory->destroy();
    GEP_DELETE(g_stdAllocator, m_pStateMachineFactory);

    g_gameObjectManager.destroy();

    DELETE_AND_NULL(m_pDummyCam);
}

void gpp::Game::update(float elapsedTime)
{
    if (!m_continueRunningGame)
    {
        return;
    }

    auto pInputHandler = g_globalManager.getInputHandler();
    auto pPhysicsSystem = g_globalManager.getPhysicsSystem();
    auto pRenderer = g_globalManager.getRenderer();

    if (pInputHandler->wasTriggered(gep::Key::Escape)) // Escape
    {
        m_continueRunningGame = false;
        return;
    }

    if (pInputHandler->wasTriggered(gep::Key::F5))
    {
        g_globalManager.getScriptingManager()->collectGarbage();
    }

    /*
    vec2 mouseDelta;
    if(pInputHandler->getMouseDelta(mouseDelta))
    {
    m_pFreeCamera->look(mouseDelta);
    }
    vec3 moveDelta;
    if(pInputHandler->isPressed(gep::Key::W))
    moveDelta.z -= 1.0f;
    if(pInputHandler->isPressed(gep::Key::S))
    moveDelta.z += 1.0f;
    if(pInputHandler->isPressed(gep::Key::D))
    moveDelta.x += 1.0f;
    if(pInputHandler->isPressed(gep::Key::A))
    moveDelta.x -= 1.0f;

    moveDelta *= elapsedTime;

    m_pFreeCamera->move(moveDelta);

    float tiltDelta = 0.0f;
    if(pInputHandler->isPressed(gep::Key::Q))
    tiltDelta -= 0.1f;
    if(pInputHandler->isPressed(gep::Key::E))
    tiltDelta += 0.1f;
    m_pFreeCamera->tilt(tiltDelta * elapsedTime);
    */
    // Modify FOV
    /*
    if (pInputHandler->isPressed(gep::Key::X))
        m_pDummyCam->setViewAngle(m_pDummyCam->getViewAngle() + 0.5f);
    if (pInputHandler->isPressed(gep::Key::Z))
        m_pDummyCam->setViewAngle(m_pDummyCam->getViewAngle() - 0.5f);
    */

    if (pInputHandler->wasTriggered(gep::Key::F9))
        pPhysicsSystem->setDebugDrawingEnabled(!pPhysicsSystem->getDebugDrawingEnabled());
    if (pInputHandler->wasTriggered(gep::Key::F8)) // Toggle VSync
        pRenderer->setVSyncEnabled(!pRenderer->getVSyncEnabled());

    auto& debugRenderer = pRenderer->getDebugRenderer();
    //debugRenderer.printText(vec3(0.0f), "Origin");

    //// Draw world axes
    //debugRenderer.drawLocalAxes(vec3(0.0f), 30.0f);
    //debugRenderer.printText(vec3(30.0f, 0.0f,  0.0f ), "X", Color::red());
    //debugRenderer.printText(vec3(0.0f,  30.0f, 0.0f ), "Y", Color::green());
    //debugRenderer.printText(vec3(0.0f,  0.0f,  30.0f), "Z", Color::blue());
    
    g_gameObjectManager.update(elapsedTime);
    auto activeCamObj = g_gameObjectManager.getCurrentCameraObject()->getComponent<CameraComponent>();
    if(activeCamObj)
    {
     //   g_globalManager.getSoundSystem()->setListenerPosition(activeCamObj->getWorldPosition());
     //   g_globalManager.getSoundSystem()->setListenerOrientation(activeCamObj->getWorldRotation());
    }
}

void gpp::Game::render(gep::IRendererExtractor& extractor)
{
    auto activeCam = g_globalManager.getCameraManager()->getActiveCamera();
    DebugMarkerSection marker(extractor, "Main");
    extractor.setCamera(activeCam);

    auto& context2D = extractor.getContext2D();
    float avg = g_globalManager.getUpdateFramework()->calcElapsedTimeAverage(60);
    float fps = 1.0f / avg;

    context2D.printText(g_globalManager.getRenderer()->toNormalizedScreenPosition(uvec2(10, 5)), gep::format("FPS: %f", fps).c_str());
    context2D.printText(g_globalManager.getRenderer()->toNormalizedScreenPosition(uvec2(10, 20)), gep::format("Memory used by lua: %d KB", g_globalManager.getScriptingManager()->memoryUsed()).c_str());
}

void gpp::Game::setUpStateMachine()
{
    using namespace sm;

    auto pLogging = g_globalManager.getLogging();
    m_pStateMachine->setLogging(pLogging);

    auto state_loading = m_pStateMachine->create<State>("loading");
    auto state_mainMenu = m_pStateMachine->create<State>("mainMenu");
    auto state_gameRunning = m_pStateMachine->create<StateMachine>("gameRunning");

    auto leaveGameCondition = [&](){
        return !m_continueRunningGame;
    };

    m_pStateMachine->addTransition("__enter", "loading");
    m_pStateMachine->addTransition("loading", "mainMenu");
    m_pStateMachine->addTransition("mainMenu", "__leave", [](){
        return g_globalManager.getInputHandler()->wasTriggered(Key::Escape);
    });
    m_pStateMachine->addTransition("mainMenu", "gameRunning");
    m_pStateMachine->addTransition("gameRunning", "__leave", [](){
        return g_globalManager.getInputHandler()->wasTriggered(Key::Escape);
    });

    // Add listeners
    //////////////////////////////////////////////////////////////////////////
    m_pStateMachine->getLeaveEvent()->registerListener([](LeaveEventData*){
        g_globalManager.getUpdateFramework()->stop();
        return gep::EventResult::Handled;
    });

    // Finalize
    //////////////////////////////////////////////////////////////////////////
    pLogging->logMessage("State machine legend:\n"
                         "  >> Entering state or state machine\n"
                         "  << Leaving state or state machine");
}

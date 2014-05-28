#include "stdafx.h"
#include "gpp/gameObjectSystem.h"
#include <algorithm>

#include "gep/globalManager.h"
#include "gep/interfaces/logging.h"

//GameObjectManager

//singleton static members
gpp::GameObjectManager* volatile gep::DoubleLockingSingleton<gpp::GameObjectManager>::s_instance = nullptr;
gep::Mutex gep::DoubleLockingSingleton<gpp::GameObjectManager>::s_creationMutex;

gpp::GameObjectManager::GameObjectManager():
    m_gameObjects(),
    m_state(State::PreInitialization),
    m_tempAllocator(true, 1024)
{
}

gpp::GameObjectManager::~GameObjectManager()
{

}

gpp::GameObject* gpp::GameObjectManager::createGameObject(const std::string& guid)
{
    GEP_ASSERT(m_state == State::PreInitialization, "You are not allowed to create game objects after the initialization process.");
	GameObject* gameObject = nullptr;
    GEP_ASSERT(!m_gameObjects.tryGet(guid, gameObject), "GameObject %s already exists!", guid.c_str());
    gameObject = new GameObject();
    gameObject->m_name = guid;
    m_gameObjects[guid] = gameObject;
    return gameObject;
}

gpp::GameObject* gpp::GameObjectManager::getGameObject(const std::string& guid)
{
	GameObject* pGameObject = nullptr;
	if(!m_gameObjects.tryGet(guid, pGameObject))
	{
		g_globalManager.getLogging()->logWarning("Attempt to obtain non-existant game object '%s'",
			guid.c_str());
	}
    return pGameObject;
}

void gpp::GameObjectManager::initialize()
{
    for(auto pGameObject : m_gameObjects.values())
    {
        pGameObject->initialize();
    }
    m_state = State::PostInitialization;
}

void gpp::GameObjectManager::destroy()
{
    for(auto& gameObject : m_gameObjects.values())
    {
        gameObject->destroy();
        DELETE_AND_NULL(gameObject);
    }
    m_gameObjects.clear();
}

void gpp::GameObjectManager::update(float elapsedMs)
{
    for(auto gameObject : m_gameObjects.values())
    {
        gameObject->update(elapsedMs);
    }
}

gpp::GameObject::GameObject() :
    m_name(),
    m_isActive(true),
    m_defaultTransform(),
    m_transform(&m_defaultTransform),
    m_components(),
    m_updateQueue()
{
}

gpp::GameObject::~GameObject()
{

}

void gpp::GameObject::setPosition(const gep::vec3& pos)
{
    m_transform->setPosition(pos);
}

void gpp::GameObject::setRotation(const gep::Quaternion& rot)
{
    m_transform->setRotation(rot);
}

void gpp::GameObject::setBaseOrientation(const gep::Quaternion& orientation)
{
    m_transform->setBaseOrientation(orientation);
}

void gpp::GameObject::setScale(const gep::vec3& scale)
{
    m_transform->setScale(scale);
}

gep::vec3 gpp::GameObject::getPosition()
{
    return m_transform->getPosition();
}

gep::Quaternion gpp::GameObject::getRotation()
{
    return m_transform->getRotation();
}

gep::vec3 gpp::GameObject::getScale()
{
    return m_transform->getScale();
}

void gpp::GameObject::update(float elapsedMs)
{
    for(auto component :  m_updateQueue)
    {
        component.component->update(elapsedMs);
    }
}

void gpp::GameObject::initialize()
{
    auto pAllocator = GameObjectManager::instance().getTempAllocator();

    auto toInit = gep::DynamicArray<ComponentWrapper*>(pAllocator);
    toInit.reserve(m_components.count());

    for(auto& wrapper : m_components.values())
    {
        toInit.append(&wrapper);
    }

    std::sort(toInit.begin(), toInit.end(), [](ComponentWrapper* lhs, ComponentWrapper* rhs){
        return lhs->initializationPriority < rhs->initializationPriority;
    });

    for(auto wrapper : toInit)
    {
        wrapper->component->initalize();
        GEP_ASSERT(wrapper->component->getState() != IComponent::State::Initial,
                    "A game component must set its state within its initialize function!");
    }
}

void gpp::GameObject::destroy()
{
    auto pAllocator = GameObjectManager::instance().getTempAllocator();

    // Create a sorted array of all component instances.
    auto toDestroy = gep::DynamicArray<ComponentWrapper*>(pAllocator);
    toDestroy.reserve(m_components.count());

    for(auto& wrapper : m_components.values())
    {
        toDestroy.append(&wrapper);
    }

    // sort so least prioritized components come first.
    std::sort(toDestroy.begin(), toDestroy.end(), [](ComponentWrapper* lhs, ComponentWrapper* rhs){
        return lhs->initializationPriority > rhs->initializationPriority;
    });

    // Call destroy on all components
    for(auto wrapper : toDestroy)
    {
        wrapper->component->destroy();

    }

    // Delete the components.
    for(auto wrapper : toDestroy)
    {
        gep::deleteAndNull(wrapper->component);
    }

    m_components.clear();
    m_updateQueue.resize(0);
}

gep::mat4 gpp::GameObject::getTransformationMatrix()
{
    return m_transform->getTransformationMatrix();
}

gep::vec3 gpp::GameObject::getViewDirection()
{
    return m_transform->getViewDirection();
}

gep::vec3 gpp::GameObject::getUpDirection()
{
    return m_transform->getUpDirection();
}

gep::vec3 gpp::GameObject::getRightDirection()
{
    return m_transform->getRightDirection();
}

void gpp::GameObject::setComponentStates(IComponent::State::Enum value)
{
    for (auto& wrapper : m_components.values())
    {
        wrapper.component->setState(value);
    }
}

void gpp::GameObject::setBaseViewDirection(const gep::vec3& direction)
{
    m_transform->setBaseViewDirection(direction);
}


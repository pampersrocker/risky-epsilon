#pragma once
#include "gep/interfaces/scripting.h"

namespace gep
{
    class FreeCamera;
    class IRendererExtractor;
}

namespace gpp { namespace sm {

    class StateMachineFactory;
    class StateMachine;

}} // namespace gpp::sm

namespace gpp
{
    class GameObjectManager;

    class GPP_API Game
    {
        sm::StateMachineFactory* m_pStateMachineFactory;

        gep::FreeCamera* m_pDummyCam;
        sm::StateMachine* m_pStateMachine;
        bool m_continueRunningGame;

    public:
        Game();

        virtual ~Game();

        void initialize();
        void destroy();
        void update(float elapsedTime);
        void render(gep::IRendererExtractor& extractor);

        void setUpStateMachine();
        void makeScriptBindings();

        void bindEnums();
        void bindOther();

        inline sm::StateMachine* getStateMachine()
        {
            GEP_ASSERT(m_pStateMachine, "state machine not initialized!");
            return m_pStateMachine;
        }

        inline sm::StateMachineFactory* getStateMachineFactory()
        {
            GEP_ASSERT(m_pStateMachineFactory, "state machine factory not initialized!");
            return m_pStateMachineFactory;
        }

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(getStateMachine)
            LUA_BIND_FUNCTION(getStateMachineFactory)
        LUA_BIND_REFERENCE_TYPE_END
    };
}

#pragma once
#include "gep/interfaces/scripting.h"

#include "gep/interfaces/events.h"

namespace gpp { namespace sm {

    class GPP_API EnterEventData
    {
        friend class State;
        friend class StateMachine;

    public:
        EnterEventData();

        State* getState();

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(getState)
            LUA_BIND_REFERENCE_TYPE_END

    private:
        State* m_pCurrentState;
    };
    typedef gep::Event<EnterEventData*> EnterEvent_t;

}} // namespace gpp::sm

#include "stdafx.h"
#include "gpp/stateMachines/enterEvent.h"

gpp::sm::EnterEventData::EnterEventData() :
    m_pCurrentState(nullptr)
{
}

gpp::sm::State* gpp::sm::EnterEventData::getState()
{
    return m_pCurrentState;
}

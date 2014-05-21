#include "stdafx.h"
#include "gpp/stateMachines/stateNameInfo.h"
#include "gpp/stateMachines/state.h"
#include "gpp/stateMachines/stateMachine.h"
#include "gpp/stateMachines/stateMachineFactory.h"

#include "gep/memory/allocator.h"

gpp::sm::StateMachineFactory::StateMachineFactory(gep::IAllocator* pAllocator) :
    m_pAllocator(pAllocator),
    m_rootName(""),
    m_rootNameInfo(m_rootName, nullptr),
    m_stateMachines(m_pAllocator)
{
}

gpp::sm::StateMachineFactory::~StateMachineFactory()
{

}

void gpp::sm::StateMachineFactory::initialize()
{
}

void gpp::sm::StateMachineFactory::destroy()
{
    for (auto pInstance : m_stateMachines.values())
    {
        GEP_DELETE(m_pAllocator, pInstance);
    }
    m_stateMachines.clear();
}

gpp::sm::StateMachine* gpp::sm::StateMachineFactory::create(const std::string& name)
{
    GEP_ASSERT(m_stateMachines.exists(name) == false, "A top-level state machine of the given name already exists!", name);

    auto nameInfo = NameInfo(name, &m_rootNameInfo);
    auto pInstance = GEP_NEW(m_pAllocator, StateMachine)(nameInfo, m_pAllocator);
    m_stateMachines[name] = pInstance;
    return pInstance;
}

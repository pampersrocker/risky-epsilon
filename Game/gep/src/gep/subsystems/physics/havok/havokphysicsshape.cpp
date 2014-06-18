#include "stdafx.h"
#include "gepimpl/subsystems/physics/havok/havokPhysicsShape.h"
#include "gepimpl/subsystems/physics/havok/entity.h"
#include "gepimpl/subsystems/physics/havok/conversion/shape.h"

void gep::HavokShapeBase::initialize(hkpShape* pShape)
{
    setHkpShape(pShape);
    pShape->removeReference();
    pShape->setUserData(reinterpret_cast<hkUlong>(this));
}

gep::HavokShape_Box::HavokShape_Box(const vec3& halfExtents)
{
    initialize(new hkpBoxShape(conversion::hk::to(halfExtents)));
}

gep::vec3 gep::HavokShape_Box::getHalfExtents() const
{
    return conversion::hk::from(static_cast<const hkpBoxShape*>(getHkpShape())->getHalfExtents());
}

void gep::HavokPhantomCallbackShapeHk::phantomEnterEvent(const hkpCollidable* phantomColl, const hkpCollidable* otherColl, const hkpCollisionInput& env)
{
    auto pHkBody = hkpGetRigidBody(otherColl);
    auto pGepBody = reinterpret_cast<HavokRigidBody*>(pHkBody->getUserData());
    m_pGepShape->getEnterEvent()->trigger(pGepBody);
}

void gep::HavokPhantomCallbackShapeHk::phantomLeaveEvent(const hkpCollidable* phantomColl, const hkpCollidable* otherColl)
{
    auto pHkBody = hkpGetRigidBody(otherColl);
    auto pGepBody = reinterpret_cast<HavokRigidBody*>(pHkBody->getUserData());
    m_pGepShape->getLeaveEvent()->trigger(pGepBody);
}

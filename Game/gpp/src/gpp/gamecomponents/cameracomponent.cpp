#include "stdafx.h"

#include "gpp/gameComponents/cameraComponent.h"
#include "gpp/gameObjectSystem.h"
#include "gep/cameras.h"
#include "gep/globalManager.h"
#include "gep/interfaces/cameraManager.h"




gpp::CameraComponent::CameraComponent():
    m_baseOrientation(),
    m_lookAt(1,0,0)
{
    m_pCamera = new gep::CameraLookAtHorizon();

}

gpp::CameraComponent::~CameraComponent()
{

}

void gpp::CameraComponent::initalize()
{
    setState(State::Active); // In case we were in the initial state.
}

void gpp::CameraComponent::update(float elapsedMS)
{
    m_pCamera->setPosition(m_pParentGameObject->getPosition());
    auto pos = m_pCamera->getPosition();

}

void gpp::CameraComponent::destroy()
{
    DELETE_AND_NULL(m_pCamera)
}

void gpp::CameraComponent::setPosition(const gep::vec3& pos)
{
   m_pCamera->setPosition(pos);
   m_pParentGameObject->setPosition(pos);
}

void gpp::CameraComponent::setRotation(const gep::Quaternion& rot)
{
    m_pParentGameObject->setRotation(rot);
}

gep::vec3 gpp::CameraComponent::getPosition()
{
    return m_pParentGameObject->getPosition();
}

gep::Quaternion gpp::CameraComponent::getRotation()
{
    return m_pParentGameObject->getRotation();
}

void gpp::CameraComponent::lookAt(const gep::vec3& target)
{
    m_lookAt = target;
    m_pCamera->lookAt(target);
}

void gpp::CameraComponent::setViewDirection(const gep::vec3& vector)
{
    m_pCamera->setViewVector(vector);
}

void gpp::CameraComponent::setState(State::Enum state)
{
    GEP_ASSERT(state != State::Initial, "Cannot set the initial state!");
    
    m_state = state;

    switch (state)
    {
    case State::Active:
        g_globalManager.getCameraManager()->setActiveCamera(m_pCamera);
        break;
    case State::Inactive:
        GEP_ASSERT(false, "Cannot directly set a camera to be Inactive."
            "If you set any other camera to Active, all other cameras will "
            "automatically be set to be Inactive.");
        break;
    default:
        GEP_ASSERT(false, "Invalid state input!", state);
        break;
    }
}

void gpp::CameraComponent::setScale(const gep::vec3& scale)
{
}

void gpp::CameraComponent::setBaseOrientation(const gep::Quaternion& orientation)
{
    m_baseOrientation = orientation;
}

void gpp::CameraComponent::setBaseViewDirection(const gep::vec3& direction)
{
    m_baseOrientation = gep::Quaternion(direction, gep::vec3(0,1,0));
}

gep::mat4 gpp::CameraComponent::getTransformationMatrix()
{
    return gep::mat4::translationMatrix(m_pCamera->getPosition()) * m_pCamera->getRotation().toMat4();
}

gep::vec3 gpp::CameraComponent::getScale()
{
    return gep::vec3(1,1,1);
}

gep::vec3 gpp::CameraComponent::getViewDirection()
{
    return m_pCamera->getViewDirection();
}

gep::vec3 gpp::CameraComponent::getUpDirection()
{
    return  m_pCamera->getUpVector();
}

gep::vec3 gpp::CameraComponent::getRightDirection()
{
    return m_pCamera->getRightDirection();
}

void gpp::CameraComponent::move(const gep::vec3& delta)
{
    gep::vec3 pos = m_pParentGameObject->getPosition();

    pos += getUpDirection() * delta.z;
    pos += getRightDirection() * delta.x;
    pos += getViewDirection() * delta.y;

    m_pCamera->setPosition(pos);
    m_pParentGameObject->setPosition(pos);



}

void gpp::CameraComponent::look(const gep::vec2& delta)
{
    m_pCamera->look(delta);
}




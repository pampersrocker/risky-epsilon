#include "stdafx.h"

#include "gpp/gameComponents/cameraComponent.h"
#include "gpp/gameObjectSystem.h"
#include "gep/cameras.h"
#include "gep/globalManager.h"
#include "gep/interfaces/cameraManager.h"




gpp::CameraComponent::CameraComponent():
    m_transform(),
    m_lookAt(1,0,0),
    m_viewTarget(),
    m_upTarget()
{
    m_pCamera = new gep::CameraLookAtHorizon();


}

gpp::CameraComponent::~CameraComponent()
{

}

void gpp::CameraComponent::initalize()
{
    setState(State::Active); // In case we were in the initial state.
    m_transform.setParent(m_pParentGameObject);
}

void gpp::CameraComponent::update(float elapsedMS)
{
    m_pCamera->setPosition(m_transform.getWorldPosition());
    
    if(m_viewTarget.getParent() != gep::getIdentityTransform())
    {
        lookAt(m_viewTarget.getWorldPosition());
    }
    if(m_upTarget.getParent() != gep::getIdentityTransform())
    {
        m_pCamera->setUpVector(m_upTarget.getUpDirection());
    }
}

void gpp::CameraComponent::destroy()
{
    DELETE_AND_NULL(m_pCamera)
}

void gpp::CameraComponent::setPosition(const gep::vec3& pos)
{
   m_transform.setPosition(pos);
   m_pCamera->setPosition(m_transform.getWorldPosition());
}

void gpp::CameraComponent::setRotation(const gep::Quaternion& rot)
{
    m_transform.setRotation(rot);
    m_pCamera->setRotation(m_transform.getWorldRotation());
}

gep::vec3 gpp::CameraComponent::getWorldPosition() const 
{
    return m_transform.getWorldPosition();
}

gep::Quaternion gpp::CameraComponent::getWorldRotation() const 
{
    return  m_pCamera->getViewMatrix().rotationPart();
}

gep::mat4 gpp::CameraComponent::getTransformationMatrix() const 
{
    return m_transform.getTransformationMatrix();
}

gep::vec3 gpp::CameraComponent::getPosition() const 
{
    return m_transform.getPosition();
}

gep::Quaternion gpp::CameraComponent::getRotation() const 
{
    return m_transform.getRotation();
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

void gpp::CameraComponent::setUpDirection(const gep::vec3& vector)
{
    m_pCamera->setUpVector(vector);
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

void gpp::CameraComponent::setBaseOrientation(const gep::Quaternion& orientation)
{
    m_transform.setBaseOrientation(orientation);
}

void gpp::CameraComponent::setBaseViewDirection(const gep::vec3& direction)
{
    m_transform.setBaseOrientation(gep::Quaternion(direction, gep::vec3(0,1,0)));
}

gep::mat4 gpp::CameraComponent::getWorldTransformationMatrix() const 
{
    return m_transform.getWorldTransformationMatrix();
}

gep::vec3 gpp::CameraComponent::getViewDirection() const 
{
    return m_pCamera->getViewDirection();
}

gep::vec3 gpp::CameraComponent::getUpDirection() const 
{
    return  m_pCamera->getUpVector();
}

gep::vec3 gpp::CameraComponent::getRightDirection() const 
{
    return m_pCamera->getRightDirection();
}

void gpp::CameraComponent::setOrthographic(const bool orthographic)
{
    m_pCamera->setOrthographic(orthographic);
}

bool gpp::CameraComponent::isOrthographic()
{
    return m_pCamera->isOrthographic();
}

void gpp::CameraComponent::move(const gep::vec3& delta)
{
    gep::vec3 pos =m_transform.getWorldPosition();

    pos += getUpDirection() * delta.z;
    pos += getRightDirection() * delta.x;
    pos += getViewDirection() * delta.y;

    m_pCamera->setPosition(pos);
    m_transform.setPosition(pos);
}

void gpp::CameraComponent::look(const gep::vec2& delta)
{
    m_pCamera->look(delta);
}

gep::ITransform* gpp::CameraComponent::getParent()
{
    return m_transform.getParent();
}

const gep::ITransform* gpp::CameraComponent::getParent() const
{
   return m_transform.getParent();
}

void gpp::CameraComponent::setParent(gep::ITransform* parent)
{
    m_transform.setParent(parent);
}

void gpp::CameraComponent::setViewTarget(gep::ITransform* viewTarget)
{
    m_viewTarget.setParent(viewTarget);
}
void gpp::CameraComponent::setUpTarget(gep::ITransform* upTarget)
{
    m_upTarget.setParent(upTarget);
}

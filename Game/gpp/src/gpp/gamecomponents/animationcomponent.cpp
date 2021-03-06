#include "stdafx.h"
#include "gpp/gameComponents/animationComponent.h"

#include "gep/interfaces/animation.h"
#include "gep/globalManager.h"
#include "gep/container/hashmap.h"
#include "gpp/gameComponents/renderComponent.h"


class RenderComponent;
gpp::AnimationComponent::AnimationComponent():
    m_skeletonPath(),
    m_animationPaths(),
    m_skinPath(),
    m_skeleton(),
    m_AnimatedSkeleton(),
    m_skins(),
    m_animations(),
    m_boneTransformations(),
    m_renderBoneDebugDrawing(false),
    m_boneDebugDrawingScale(1.0f)
{

}

gpp::AnimationComponent::~AnimationComponent()
{

}

void gpp::AnimationComponent::activate()
{

}

void gpp::AnimationComponent::deactivate()
{

}

void gpp::AnimationComponent::initalize()
{
    GEP_ASSERT(m_skeletonPath != nullptr, "Can't initialize animation component without skeleton path", m_pParentGameObject->getName().c_str());
    GEP_ASSERT(m_animationPaths.count() >= 1, "Can't initialize animation component without animation path", m_pParentGameObject->getName().c_str());
    GEP_ASSERT(m_skinPath != nullptr, "Can't initialize animation component without skin path", m_pParentGameObject->getName().c_str());

    auto animationFactory = g_globalManager.getAnimationSystem()->getAnimationFactory();

    m_skeleton = animationFactory->loadAnimation(m_skeletonPath);
    m_skins = animationFactory->loadAnimation(m_skinPath);

    m_AnimatedSkeleton = animationFactory->createAnimatedSkeleton(m_skeleton);

    
    for(auto kv : m_animationPaths)
    {
       auto anim =   animationFactory->loadAnimation(kv.value.c_str());
        m_animations[kv.key] = anim;
        m_animationControls[kv.key] = m_AnimatedSkeleton->addAnimationControl(anim);
    }

    m_AnimatedSkeleton->setParentTransform(this->getParentGameObject());
    RenderComponent* rc = m_pParentGameObject->getComponent<RenderComponent>();
    if (rc != nullptr)
    {
        rc->setBoneMapping(getBoneMapping(rc->getBoneNames().toArray()));
    }
    setState(State::Active);
}

void gpp::AnimationComponent::update( float elapsedSeconds )
{
    m_AnimatedSkeleton->update(elapsedSeconds);

    RenderComponent* rc = m_pParentGameObject->getComponent<RenderComponent>();
    if (rc != nullptr)
    {
        updateBoneTransformations();
        rc->applyBoneTransformations(m_boneTransformations.toArray());
    }

    m_AnimatedSkeleton->setBoneDebugDrawingEnabled(m_renderBoneDebugDrawing);
    m_AnimatedSkeleton->setBoneDebugDrawingScale(m_boneDebugDrawingScale);
}

void gpp::AnimationComponent::updateBoneTransformations()
{
    m_boneTransformations.clear();

    m_AnimatedSkeleton->getBoneTransformations(m_boneTransformations);
}

void gpp::AnimationComponent::destroy()
{

}

void gpp::AnimationComponent::setState( State::Enum state )
{
    GEP_ASSERT(state != State::Initial);

    auto oldState = m_state;

    if (oldState == state) { return; } // Nothing to do here.

    switch (state)
    {
    case State::Active:
        if (oldState != State::Active)
        {
            activate();
        }
        break;
    case State::Inactive:
        if (oldState == State::Active)
        {
            deactivate();
        }
        break;
    default:
        GEP_ASSERT(false, "Invalid requested state.", oldState, state);
        break;
    }

    m_state = state;
}

void gpp::AnimationComponent::setSkeletonFile(const char* path)
{
    m_skeletonPath = path;
}

void gpp::AnimationComponent::addAnimationFile(const char* animationName, const char* path)
{
   GEP_ASSERT(m_animationPaths.exists(animationName) == false, "An animation with that name alredy exists on that animation component!", animationName)
   m_animationPaths[animationName] = path;
}

void gpp::AnimationComponent::setSkinFile(const char* path)
{
    m_skinPath = path;
}

void gpp::AnimationComponent::setMasterWeight(const std::string& animName, float weight)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    m_animationControls[animName]->setMasterWeight(weight);
}

float gpp::AnimationComponent::getMasterWeight(const std::string& animName)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    return m_animationControls[animName]->getMasterWeight();
}

void gpp::AnimationComponent::setPlaybackSpeed(const std::string& animName, float speed)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    m_animationControls[animName]->setPlaybackSpeed(speed);
}

void gpp::AnimationComponent::setBoneDebugDrawingEnabled(const bool enabled)
{
  m_renderBoneDebugDrawing = enabled; 
}

void gpp::AnimationComponent::setReferencePoseWeightThreshold(const float threshold)
{

    m_AnimatedSkeleton->setReferencePoseWeightThreshold(gep::clamp(threshold, 0.001f, 1.0f));
}

float gpp::AnimationComponent::getAnimationDuration(const std::string& animName)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    return  m_animationControls[animName]->getAnimationDuration();
}

void gpp::AnimationComponent::setDebugDrawingScale(const float scale)
{
    m_boneDebugDrawingScale = scale;
}

float gpp::AnimationComponent::getLocalTime(const std::string& animName)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    return  m_animationControls[animName]->getLocalTime();
}

float gpp::AnimationComponent::getLocalTimeNormalized(const std::string& animName)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    return  m_animationControls[animName]->getLocalTime() / getAnimationDuration(animName);
}

void gpp::AnimationComponent::setLocalTime(const std::string& animName, const float time)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    m_animationControls[animName]->setLocalTime(time);
}

void gpp::AnimationComponent::setLocalTimeNormalized(const std::string& animName, const float time)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    m_animationControls[animName]->setLocalTime(time * getAnimationDuration(animName));
}

float gpp::AnimationComponent::easeIn(const std::string& animName, const float duration)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    return m_animationControls[animName]->ease(duration,true);
}

float gpp::AnimationComponent::easeOut(const std::string& animName, const float duration)
{
    GEP_ASSERT(m_animationControls.exists(animName), "The animationName provided does not exist!" )
    return m_animationControls[animName]->ease(duration, false);
}

gep::IBone* gpp::AnimationComponent::getBoneByName(const std::string& boneName)
{
    auto bone = m_AnimatedSkeleton->getBoneByName(boneName);
    bone->setParent(m_pParentGameObject);
    return bone;
}

gep::DynamicArray<gep::uint32> gpp::AnimationComponent::getBoneMapping(gep::ArrayPtr<const char*> boneNames)
{
    gep::DynamicArray<gep::uint32> result;

    //result.resize(boneNames.length());

    for(auto name :boneNames)
    {

        result.append(m_AnimatedSkeleton->findBoneForName(name));
    }

    return result;
}

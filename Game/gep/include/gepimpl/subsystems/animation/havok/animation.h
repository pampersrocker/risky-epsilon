#pragma once

#include "gep/interfaces/animation.h"
#include "gepimpl/subsystems/animation/havok/animationFactory.h"
#include "gep/container/DynamicArray.h"
#include "gepimpl/subsystems/physics/havok/conversion/quaternion.h"

namespace gep{
    class AnimationSystem : public IAnimationSystem
    {
    public:
        virtual ~AnimationSystem();
        virtual IAnimationFactory* getAnimationFactory() const;

        virtual void initialize();

        virtual void destroy();

        virtual void update( float elapsedTime );
    private:
        IAnimationFactory* m_pAnimationFactory;

    };


    

    class AnimationFileLoader;
    class AnimationResource : public IAnimationResource
    {
    public: 
        AnimationResource();
        virtual ~AnimationResource();

        virtual IResourceLoader* getLoader() override;

        virtual void setLoader( IResourceLoader* loader ) override;

        virtual void unload() override;

        virtual void finalize() override;

        virtual uint32 getFinalizeOptions() override;

        virtual bool isLoaded() override;

        virtual IResource* getSuperResource() override;

        virtual const char* getResourceType() override;

        DynamicArray<hkRefPtr<hkaSkeleton> > m_skeletons;
        DynamicArray<hkRefPtr<hkaAnimation> > m_animations;
        DynamicArray<hkRefPtr<hkaAnimationBinding> > m_bindings;
        DynamicArray<hkRefPtr<hkaMeshBinding> > m_skinBinding;
    private:
        AnimationFileLoader* m_pFileLoader;


    };

    class ITransform;
    class AnimatedSkeleton : public IAnimatedSkeleton
    {
    public:
        AnimatedSkeleton(AnimationResource* skeleton);
        virtual  ~AnimatedSkeleton() override;
        virtual void update( float elapsedMS ) override;
        virtual IAnimationControl* addAnimationControl(ResourcePtr<IAnimationResource> anim) override;
        virtual void getBoneTransformations(DynamicArray<BoneTransform>& result) override;
        virtual void setBoneDebugDrawingEnabled(const bool enabled) override {m_drawDebug = enabled;};
        virtual void setParentTransform(ITransform* parent) override {m_pTransform = parent;};
        virtual void setReferencePoseWeightThreshold(const float threshold) override {m_pHkaAnimatedSkeleton->setReferencePoseWeightThreshold(threshold);};
    private:
        void renderDebug();

        virtual void setBoneDebugDrawingScale(const float scale) override {m_debugDrawingScale = scale;};

        

        

        DynamicArray<IAnimationControl*> m_animationControls;
        hkaAnimatedSkeleton* m_pHkaAnimatedSkeleton;
        hkaPose* m_pPose;
        bool m_drawDebug;
        ITransform* m_pTransform;
        float m_debugDrawingScale;
    };


    class AnimationControl : public IAnimationControl
    {
    public:
        AnimationControl(hkRefPtr<hkaAnimationBinding> binding);
        virtual  ~AnimationControl();
        virtual void setMasterWeight(const float weight) override;
        virtual float getMasterWeight() override {return m_pHkaDefaultAnimationControl->getMasterWeight();};
        virtual void setPlaybackSpeed(const float speed) override;
        virtual hkaDefaultAnimationControl* getHkaAnimationControl();
        virtual float getAnimationDuration() override {return m_pHkaDefaultAnimationControl->getAnimationBinding()->m_animation->m_duration;};
        virtual float getLocalTime() override {return m_pHkaDefaultAnimationControl->getLocalTime();}
        virtual void setLocalTime(const float time) override {return m_pHkaDefaultAnimationControl->setLocalTime(time);};
        virtual float ease(const float duration, const bool easeInIfTrue) override { return m_pHkaDefaultAnimationControl->ease(duration, easeInIfTrue);}


    private:
        hkaDefaultAnimationControl* m_pHkaDefaultAnimationControl;
    };


    class AnimationFileLoader : public IResourceLoader
    {
        std::string m_path;
    public:
        AnimationFileLoader(const char* path);
        virtual ~AnimationFileLoader();

        virtual IResource* loadResource(IResource* pInPlace);

        AnimationResource* loadResource(AnimationResource* pInPlace);

        virtual void postLoad(ResourcePtr<IResource> pResource);

        virtual void deleteResource(IResource* pResource);

        virtual const char* getResourceType();

        virtual const char* getResourceId();

        virtual IResourceLoader* moveToHeap();

        virtual void release();

    };

}

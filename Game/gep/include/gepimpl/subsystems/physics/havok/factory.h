#pragma once
#include "gep/interfaces/physics/factory.h"

#include "gepimpl/subsystems/physics/havok/world.h"
#include "gepimpl/subsystems/physics/havok/entity.h"
#include "gepimpl/subsystems/physics/havok/characterController.h"
#include "gep/globalManager.h"
#include "gepimpl/subsystems/resourceManager.h"
#include "gepimpl/subsystems/physics/havok/conversion/shape.h"

namespace gep
{
    class CollisionMeshFileLoader;

    class CollisionMesh : public ICollisionMesh
    {
        friend class CollisionMeshFileLoader;
        
        IShape* m_pShape;
        Transform* m_pTransform;
        CollisionMeshFileLoader* m_pCollisionMeshFileLoader;
    public:
        CollisionMesh();

        virtual ~CollisionMesh();

        virtual IResourceLoader* getLoader();

        virtual void setLoader(IResourceLoader* loader);

        virtual void unload();

        virtual void finalize();

        virtual uint32 getFinalizeOptions();

        virtual bool isLoaded();

        virtual IResource* getSuperResource();

        virtual const char* getResourceType();

        virtual IShape* getShape() override;

        virtual const IShape* getShape() const override;

    private:
        
        void setShape(IShape* shape);
        void setTransform(Transform* transform);

    };

    class CollisionMeshFileLoader : public IResourceLoader
    {
        IAllocator* m_pAllocator;
        std::string m_path;
    public:
        CollisionMeshFileLoader(IAllocator* pAllocator, const char* path);
        virtual ~CollisionMeshFileLoader();

        virtual IResource* loadResource(IResource* pInPlace);

        CollisionMesh* loadResource(CollisionMesh* pInPlace);

        virtual void postLoad(ResourcePtr<IResource> pResource);

        virtual void deleteResource(IResource* pResource);

        virtual const char* getResourceType();

        virtual const char* getResourceId();

        virtual IResourceLoader* moveToHeap();

        virtual void release();

    };

    class HavokPhysicsFactory : public IPhysicsFactory
    {
        IAllocator* m_pAllocator;
    public:

        HavokPhysicsFactory(IAllocator* allocator);
        virtual ~HavokPhysicsFactory();

        virtual void initialize();
        virtual void destroy();

        virtual IAllocator* getAllocator() override;
        virtual void setAllocator(IAllocator* allocator) override;

        virtual IWorld* createWorld(const WorldCInfo& cinfo) const override;
        virtual IRigidBody* createRigidBody(const RigidBodyCInfo& cinfo) const override;
        virtual ICharacterRigidBody* createCharacterRigidBody(const CharacterRigidBodyCInfo& cinfo) const override;

        virtual ResourcePtr<ICollisionMesh> loadCollisionMesh(const char* path);
        virtual IShape* loadCollisionMeshFromLua(const char* path);

        virtual IBoxShape* createBox(const vec3& halfExtends) override;
        virtual ISphereShape* createSphere(float radius) override;
        virtual ICapsuleShape* createCapsule(const vec3& start, const vec3& end, float radius) override;
        virtual ICylinderShape* createCylinder(const vec3& start, const vec3& end, float radius) override;
        virtual ITriangleShape* createTriangle(const vec3& vertex0, const vec3& vertex1, const vec3& vertex2) override;
        virtual IConvexTranslateShape* createConvexTranslateShape(IShape* pShape, const vec3& translation) override;
        virtual ITransformShape* createTransformShape(IShape* pShape, const vec3& translation, const Quaternion& rotation) override;
        virtual IBoundingVolumeShape* createBoundingVolumeShape(IShape* pBounding, IShape* pChild) override;
        virtual IPhantomCallbackShape* createPhantomCallbackShape() override;

        virtual ICollisionFilter* createCollisionFilter_Simple() override;

    private:
        template<typename T_Shape>
        T_Shape* postProcessNewShape(T_Shape* pShape)
        {
            pShape->initialize();
            return pShape;
        }
    };
}

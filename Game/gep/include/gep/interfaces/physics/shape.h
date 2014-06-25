#pragma once
#include "gep/math3d/vec3.h"
#include "gep/math3d/transform.h"
#include "gep/ReferenceCounting.h"
#include "gep/interfaces/events.h"

namespace gep
{
    class IRigidBody;

    /// \brief Purely static struct that serves as an enum.
    struct ShapeType
    {
        enum Enum
        {
            Sphere = 0,
            Cylinder = 1,
            Triangle = 2,
            Box = 3,
            Capsule = 4,
            ConvexVertices = 5,
            ConvexTranslate = 10,
            ConvexTransform = 11,
            Transform = 14,
            BoundingVolume = 30,
            PhantomCallback = 32,
        };

        GEP_DISALLOW_CONSTRUCTION(ShapeType);
    };
    
    class IShape : public ReferenceCounted
    {
    public:

        virtual ShapeType::Enum getShapeType() const = 0;
        virtual const ITransform* getTransform() const = 0;

        LUA_BIND_REFERENCE_TYPE_BEGIN
        LUA_BIND_REFERENCE_TYPE_END
    };

    class IBoxShape : public IShape
    {
        inline virtual ShapeType::Enum getShapeType() const override { return ShapeType::Box; }

        virtual vec3 getHalfExtents() const = 0;

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(getHalfExtents)
        LUA_BIND_REFERENCE_TYPE_END
    };

    class SphereShape : public IShape
    {
        float m_radius;
        const ITransform* m_pTransform;
    public:
        SphereShape(float radius) : m_radius(radius), m_pTransform(new Transform()) {}
        inline ~SphereShape(){DELETE_AND_NULL(m_pTransform)}

        inline virtual ShapeType::Enum getShapeType() const override { return ShapeType::Sphere; }

        inline float getRadius() const { return m_radius; }
        inline void setRadius(float value) { m_radius = value; }
        const ITransform* getTransform() const {return m_pTransform;}

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(getRadius)
            LUA_BIND_FUNCTION(setRadius)
        LUA_BIND_REFERENCE_TYPE_END
    };

    class BoundingVolumeShape : public IShape
    {
    public:
        BoundingVolumeShape(const IShape* pBoundingShape, const IShape* pChildShape) :
            m_pBoundingShape(pBoundingShape),
            m_pChildShape(pChildShape),
            m_pTransform(new Transform())
        {
            const_cast<IShape*>(m_pBoundingShape)->addReference();
            const_cast<IShape*>(m_pChildShape)->addReference();
        }

        ~BoundingVolumeShape()
        {
            const_cast<IShape*>(m_pBoundingShape)->removeReference();
            const_cast<IShape*>(m_pChildShape)->removeReference();
            DELETE_AND_NULL(m_pTransform);
        }

        inline virtual ShapeType::Enum getShapeType() const override { return ShapeType::BoundingVolume; }

        inline const IShape* getBoundingShape() { return m_pBoundingShape; }
        inline const IShape* getChildShape() { return m_pChildShape; }
        const ITransform* getTransform() const {return m_pTransform;}

        LUA_BIND_REFERENCE_TYPE_BEGIN
        LUA_BIND_REFERENCE_TYPE_END

    private:
        const IShape* m_pBoundingShape;
        const IShape* m_pChildShape;
        const ITransform* m_pTransform;
    };
    
    class IPhantomCallbackShape : public IShape
    {
    public:

        inline virtual ShapeType::Enum getShapeType() const override { return ShapeType::PhantomCallback; }

        virtual Event<IRigidBody*>* getEnterEvent() = 0;
        virtual Event<IRigidBody*>* getLeaveEvent() = 0;

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(getEnterEvent)
            LUA_BIND_FUNCTION(getLeaveEvent)
        LUA_BIND_REFERENCE_TYPE_END
    };

    class ConvexTranslateShape : public IShape
    {
        mutable SmartPtr<IShape> m_pShape;
        vec3 m_translation;
    public:
        inline ConvexTranslateShape(IShape* pShape, const vec3& translation) :
            m_pShape(pShape),
            m_translation(translation)
        {
        }

        inline virtual ShapeType::Enum getShapeType() const override { return ShapeType::ConvexTranslate; }

        inline IShape* getShape() { return m_pShape.get(); }
        inline void setShape(IShape* pShape) { m_pShape = pShape; }
        inline const vec3& getTranslation() const { return m_translation; }
        inline void setTranslation(const vec3 & value) { m_translation = value; }
        const ITransform* getTransform() const override { return nullptr; }

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(getShape)
            LUA_BIND_FUNCTION(setShape)
            LUA_BIND_FUNCTION_NAMED(getTranslationCopy, "getTranslation")
            LUA_BIND_FUNCTION(setTranslation)
        LUA_BIND_REFERENCE_TYPE_END

    private:
        inline vec3 getTranslationCopy() const { return m_translation; }
    };
}

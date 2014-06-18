#pragma once
#include "gep/interfaces/physics.h"
#include "gepimpl/havok/util.h"

namespace gep
{
    class HavokShapeBase
    {
        hkRefPtr<hkpShape> m_pHkpShape;
    public:
        virtual ~HavokShapeBase() {}

        void initialize();

        inline       hkpShape* getHkpShape()       { return m_pHkpShape.val(); }
        inline const hkpShape* getHkpShape() const { return m_pHkpShape.val(); }
        inline void setHkpShape(hkpShape* pHkpShape) { m_pHkpShape = pHkpShape; }

    protected:
        void initialize(hkpShape* pShape);
    };

    class HavokShape_Box :
        public IBoxShape,
        public HavokShapeBase
    {
        vec3 m_cachedHalfExtents;
    public:
        HavokShape_Box(const vec3& halfExtents);
        virtual ~HavokShape_Box() {}

        virtual vec3 getHalfExtents() const override;

        virtual const ITransform* getTransform() const override
        {
            GEP_ASSERT(false, "Not implemented.");
            return nullptr;
        }
    };
    

    class HavokMeshShape : public IShape
    {
        hkpShape* m_pHkActualShape;
        const ITransform* m_pTransform;
    public:
        HavokMeshShape(hkpShape* havokShape) : 
            m_pHkActualShape(nullptr),
            m_pTransform(nullptr)
        {
            setHkShape(havokShape); 
        }
        ~HavokMeshShape()
        {
            hk::removeRefAndNull(m_pHkActualShape); 
            DELETE_AND_NULL(m_pTransform);
        }

        virtual ShapeType::Enum getShapeType() const override { return ShapeType::Triangle; }

        hkpShape* getHkShape() { return m_pHkActualShape; }
        const hkpShape* getHkShape() const { return m_pHkActualShape; }
        void setHkShape(hkpShape* value)
        {
            if (m_pHkActualShape == value) return;
            
            if (m_pHkActualShape)
                m_pHkActualShape->removeReference();
            
            m_pHkActualShape = value;

            if (m_pHkActualShape)
                m_pHkActualShape->addReference();
        }

        void setTransform(const ITransform* transform) {m_pTransform = transform;}

        const ITransform* getTransform() const{return m_pTransform;}


    };

    class HavokPhantomCallbackShapeGep;

    class HavokPhantomCallbackShapeHk : public hkpPhantomCallbackShape
    {
        friend class HavokPhantomCallbackShapeGep;
    public:
        HavokPhantomCallbackShapeHk() :
            hkpPhantomCallbackShape(),
            m_pGepShape(nullptr)
        {
        }

        virtual void phantomEnterEvent(const hkpCollidable* phantomColl, const hkpCollidable* otherColl, const hkpCollisionInput& env) override;
        virtual void phantomLeaveEvent(const hkpCollidable* phantomColl, const hkpCollidable* otherColl) override;

        inline HavokPhantomCallbackShapeGep* getOwner() { return m_pGepShape; }

    private:
        HavokPhantomCallbackShapeGep* m_pGepShape;
    };

    class HavokPhantomCallbackShapeGep : public IPhantomCallbackShape
    {
        const ITransform* m_pTransform;
    public:

        HavokPhantomCallbackShapeGep(): m_pTransform(new Transform()) { m_hkShape.m_pGepShape = this; }
        ~HavokPhantomCallbackShapeGep(){DELETE_AND_NULL(m_pTransform);}
        virtual Event<IRigidBody*>* getEnterEvent() override { return &m_enterEvent; }
        virtual Event<IRigidBody*>* getLeaveEvent() override { return &m_leaveEvent; }

        inline HavokPhantomCallbackShapeHk* getHkShape() { return &m_hkShape; }
        const ITransform* getTransform() const{return m_pTransform;}

    private:
        Event<IRigidBody*> m_enterEvent;
        Event<IRigidBody*> m_leaveEvent;

        HavokPhantomCallbackShapeHk m_hkShape;
    };
}

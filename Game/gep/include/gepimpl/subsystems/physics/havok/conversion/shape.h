#pragma once

#include "gep/interfaces/physics/shape.h"

#include "gepimpl/subsystems/physics/havok/havokPhysicsShape.h"

namespace gep {
namespace conversion {
namespace hk {

    const hkpShape* to(const IShape* in_gepShape);

    inline hkpShape* to(IShape* in_gepShape)
    {
        hkpShape* result = nullptr;

        GEP_ASSERT(in_gepShape, "Shape is a nullptr!");

        switch (in_gepShape->getShapeType())
        {
        case ShapeType::Box:
            {
                auto pWrapper = static_cast<HavokShape_Box*>(in_gepShape);
                GEP_ASSERT(dynamic_cast<HavokShape_Box*>(in_gepShape) != nullptr, "Shape type does not match the actual class type!");
                result = pWrapper->getHkpShape();
            }
            break;
        case ShapeType::Sphere:
            {
                auto sphere = static_cast<SphereShape*>(in_gepShape);
                GEP_ASSERT(dynamic_cast<SphereShape*>(in_gepShape) != nullptr, "Shape type does not match the actual class type!");
                result = new hkpSphereShape(sphere->getRadius());
            }
            break;
        case ShapeType::Triangle:
            {
                auto mesh = static_cast<HavokMeshShape*>(in_gepShape);
                GEP_ASSERT(dynamic_cast<HavokMeshShape*>(in_gepShape) != nullptr, "Shape type does not match the actual class type!");
                result = mesh->getHkShape();
            }
            break;
        case ShapeType::ConvexTranslate:
            {
                auto pTransShape = static_cast<ConvexTranslateShape*>(in_gepShape);
                GEP_ASSERT(dynamic_cast<ConvexTranslateShape*>(in_gepShape) != nullptr, "Shape type does not match the actual class type!");
                auto pChildShape = to(pTransShape->getShape());
                auto translation = to(pTransShape->getTranslation());
                result = new hkpConvexTranslateShape(static_cast<hkpConvexShape*>(pChildShape), translation);
            }
            break;
        case ShapeType::BoundingVolume:
            {
                auto bvShape = static_cast<BoundingVolumeShape*>(in_gepShape);
                GEP_ASSERT(dynamic_cast<BoundingVolumeShape*>(in_gepShape) != nullptr, "Shape type does not match the actual class type!");
                result = new hkpBvShape(to(bvShape->getBoundingShape()),
                                        to(bvShape->getChildShape()));
            }
            break;
        case ShapeType::PhantomCallback:
            {
                result = static_cast<HavokPhantomCallbackShapeGep*>(in_gepShape)->getHkShape();
            }
            break;
        default:
            GEP_ASSERT(false, "Unsupported shape type!");
            break;
        }

        return result;
    }

    inline const hkpShape* to(const IShape* in_gepShape)
    {
        return to( const_cast<IShape*>(in_gepShape) );
    }

    //////////////////////////////////////////////////////////////////////////
    
    const IShape* from(const hkpShape* in_hkShape);

    inline IShape* from(hkpShape* in_hkShape)
    {
        IShape* result = nullptr;
        switch (in_hkShape->getType())
        {
        case hkcdShapeType::BOX:
            {
                auto pActual = static_cast<const hkpBoxShape*>(in_hkShape);
                result = static_cast<HavokShape_Box*>(reinterpret_cast<HavokShapeBase*>(pActual->getUserData()));
            }
            break;
        case hkcdShapeType::SPHERE:
            {
                const auto* sphereShape = static_cast<const hkpSphereShape*>(in_hkShape);
                result = GEP_NEW(g_stdAllocator, SphereShape)(sphereShape->getRadius());
            }
            break;
        //TODO: Check if it is actually ok to put all of these into a HavokMeshShape!
        case hkcdShapeType::TRIANGLE:
        case hkcdShapeType::BV_COMPRESSED_MESH:
        case hkcdShapeType::CONVEX_VERTICES:
            {
                result = GEP_NEW(g_stdAllocator, HavokMeshShape)(in_hkShape);
            }
            break;
        case hkcdShapeType::CONVEX_TRANSLATE:
            {
                auto pTransShape = static_cast<const hkpConvexTranslateShape*>(in_hkShape);
                GEP_ASSERT(dynamic_cast<hkpConvexTranslateShape*>(in_hkShape) != nullptr, "Shape type does not match the actual class type!");
                auto pChildShape = from(pTransShape->getChildShape());
                auto translation = from(pTransShape->getTranslation());
                result = GEP_NEW(g_stdAllocator, ConvexTranslateShape)(const_cast<IShape*>(pChildShape), translation);
            }
            break;
        case hkcdShapeType::BV:
            {
                auto pActualShape = static_cast<const hkpBvShape*>(in_hkShape);
                auto pBounding = from(pActualShape->m_boundingVolumeShape);
                auto pChild = from(pActualShape->m_childShape.getChild());
                result = GEP_NEW(g_stdAllocator, BoundingVolumeShape)(pBounding, pChild);
            }
            break;
        case ShapeType::PhantomCallback:
            {
                result = static_cast<HavokPhantomCallbackShapeHk*>(in_hkShape)->getOwner();
            }
            break;
        default:
            GEP_ASSERT(false, "Unsupported shape type!");
            break;
        }

        return result;
    }

    inline const IShape* from(const hkpShape* in_hkShape)
    {
        return from( const_cast<hkpShape*>(in_hkShape) );
    }

}}} // namespace gep::conversion::hk

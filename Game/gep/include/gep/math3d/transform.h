#pragma once
#include "gep/math3d/vec3.h"
#include "gep/math3d/quaternion.h"

namespace gep
{
    class ITransform
    {
    public:
        virtual ~ITransform() {}

        virtual void setPosition(const gep::vec3& pos) = 0;
        virtual void setRotation(const gep::Quaternion& rot) = 0;
        virtual void setScale(const gep::vec3& scale) = 0;
        virtual void setBaseOrientation(const gep::Quaternion& orientation) = 0;
        virtual void setBaseViewDirection(const gep::vec3& direction) =0;

        virtual gep::mat4 getWorldTransformationMatrix() const = 0;
        virtual gep::vec3 getWorldPosition() const = 0;
        virtual gep::Quaternion getWorldRotation() const = 0;
        virtual gep::vec3 getWorldScale() const = 0;
        
        virtual gep::mat4 getTransformationMatrix() const = 0;
        virtual gep::vec3 getPosition() const =0;
        virtual gep::Quaternion getRotation() const = 0;
        virtual gep::vec3 getScale() const = 0;

        virtual gep::vec3 getViewDirection() const = 0;
        virtual gep::vec3 getUpDirection() const = 0;
        virtual gep::vec3 getRightDirection() const = 0;
        virtual void setParent(const gep::ITransform* parent) = 0;
        virtual const gep::ITransform* getParent() = 0;

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(setPosition)
            LUA_BIND_FUNCTION(setRotation)
            LUA_BIND_FUNCTION(setScale)
            LUA_BIND_FUNCTION(setBaseOrientation)
            LUA_BIND_FUNCTION(setBaseViewDirection)
            LUA_BIND_FUNCTION(getWorldTransformationMatrix)
            LUA_BIND_FUNCTION(getWorldPosition)
            LUA_BIND_FUNCTION(getWorldRotation)
            LUA_BIND_FUNCTION(getWorldScale)
            LUA_BIND_FUNCTION(getTransformationMatrix)
            LUA_BIND_FUNCTION(getPosition)
            LUA_BIND_FUNCTION(getRotation)
            LUA_BIND_FUNCTION(getScale)
            LUA_BIND_FUNCTION(getViewDirection)
            LUA_BIND_FUNCTION(getUpDirection)
            LUA_BIND_FUNCTION(getRightDirection)
            LUA_BIND_FUNCTION(setParent)
         //   LUA_BIND_FUNCTION(getParent)  //TODO: Crashes the script bindings
        LUA_BIND_REFERENCE_TYPE_END


    };

    class Transform : public ITransform
    {
    public:
        Transform():
            m_position(),
            m_scale(1,1,1),
            m_rotation(),
            m_baseOrientation(),
            m_pParent(nullptr)
        {}
        virtual ~Transform() {}

        virtual void setPosition(const gep::vec3& pos) override { m_position = pos; }
        virtual void setRotation(const gep::Quaternion& rot) override { m_rotation = rot; }
        virtual void setScale(const gep::vec3& scale) override { m_scale = scale; }
        virtual void setBaseOrientation(const gep::Quaternion& orientation) override { m_baseOrientation = orientation;}
        virtual void setBaseViewDirection(const gep::vec3& direction) override { m_baseOrientation = gep::Quaternion(direction, gep::vec3(0,1,0));}

        virtual gep::vec3 getWorldPosition() const override 
        {
            if (m_pParent)
            {
                return  getWorldTransformationMatrix().translationPart();
            }
            return m_position; 
        }
        virtual gep::Quaternion getWorldRotation() const override 
        { 
            if(m_pParent)
            {
                return m_pParent->getWorldRotation() * m_rotation;
            }

            return m_rotation; 
        }
        virtual gep::vec3 getWorldScale() const override
        { 
            if (m_pParent)
            {
                return m_pParent->getWorldScale() * m_scale;
            }

            return m_scale; 
        }
        
        //TODO: extend for scale
        virtual gep::mat4 getWorldTransformationMatrix() const override
        {
            if (m_pParent)
            {
                return  m_pParent->getWorldTransformationMatrix() * ( gep::mat4::scaleMatrix(m_scale) * gep::mat4::translationMatrix(m_position) * m_rotation .toMat4());
            }
            return gep::mat4::scaleMatrix(m_scale) * gep::mat4::translationMatrix(m_position) * m_rotation .toMat4() ; 
        }
        virtual gep::vec3 getViewDirection() const override {return getWorldRotation().toMat3() * gep::vec3(0,1,0);}
        virtual gep::vec3 getUpDirection() const override {return  getWorldRotation().toMat3() * gep::vec3(0,0,1);}
        virtual gep::vec3 getRightDirection() const override {return getWorldRotation().toMat3() * gep::vec3(1,0,0);}

        virtual void setParent(const gep::ITransform* parent) override
        {
          m_pParent = parent;
        }

        virtual const gep::ITransform* getParent() override
        {
            return m_pParent;
        }

        virtual gep::mat4 getTransformationMatrix() const override
        {
          return gep::mat4::translationMatrix(m_position) * m_rotation .toMat4(); 
        }

        virtual gep::vec3 getPosition() const override
        {
            return m_position;
        }

        virtual gep::Quaternion getRotation() const override
        {
           return m_rotation;
        }

        virtual gep::vec3 getScale() const override
        {
            return m_scale;
        }

    protected:
        gep::vec3 m_position;
        gep::vec3 m_scale;
        gep::Quaternion m_rotation;
        gep::Quaternion m_baseOrientation;
        const gep::ITransform* m_pParent;

    };
}

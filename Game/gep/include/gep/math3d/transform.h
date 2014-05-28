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

        virtual gep::mat4 getTransformationMatrix() = 0;
        virtual gep::vec3 getPosition() = 0;
        virtual gep::Quaternion getRotation() = 0;
        virtual gep::vec3 getScale() = 0;
        virtual gep::vec3 getViewDirection() = 0;
        virtual gep::vec3 getUpDirection() = 0;
        virtual gep::vec3 getRightDirection() = 0;


    };

    class Transform : public ITransform
    {
    public:
        Transform():
            m_position(),
            m_scale(),
            m_rotation(),
            m_baseOrientation()
        {}
        virtual ~Transform() {}

        virtual void setPosition(const gep::vec3& pos) override { m_position = pos; }
        virtual void setRotation(const gep::Quaternion& rot) override { m_rotation = rot; }
        virtual void setScale(const gep::vec3& scale) override { m_scale = scale; }
        virtual void setBaseOrientation(const gep::Quaternion& orientation) override { m_baseOrientation = orientation;}
        virtual void setBaseViewDirection(const gep::vec3& direction) override { m_baseOrientation = gep::Quaternion(direction, gep::vec3(0,1,0));}
        virtual gep::vec3 getPosition() override { return m_position; }
        virtual gep::Quaternion getRotation() override { return m_rotation; }
        virtual gep::vec3 getScale() override { return m_scale; }
        //TODO: extend for scale
        virtual gep::mat4 getTransformationMatrix() override { return gep::mat4::translationMatrix(m_position) * m_rotation .toMat4() ; }
        virtual gep::vec3 getViewDirection() override {return (m_rotation * m_baseOrientation).toMat3() * gep::vec3(0,1,0);}
        virtual gep::vec3 getUpDirection() override {return  (m_rotation * m_baseOrientation).toMat3() * gep::vec3(0,0,1);}
        virtual gep::vec3 getRightDirection() override {return (m_rotation * m_baseOrientation).toMat3() * gep::vec3(1,0,0);}

    private:
        gep::vec3 m_position;
        gep::vec3 m_scale;
        gep::Quaternion m_rotation;
        gep::Quaternion m_baseOrientation;

    };
}

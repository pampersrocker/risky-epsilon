#pragma once

#include "gep/cameras.h"
#include "gpp/gameObjectSystem.h"
#include "gep/math3d/vec3.h"
#include "gep/math3d/quaternion.h"

namespace gpp 
{
    // TODO inherit from ITransform
    class CameraComponent : public Component, public ITransform
    {
    public:
        CameraComponent();

        virtual ~CameraComponent();

        virtual void initalize();
        virtual void update(float elapsedMS);
        virtual void destroy();

        virtual void setPosition(const gep::vec3& pos) override;

        virtual void setRotation(const gep::Quaternion& rot) override;
        
        virtual gep::vec3 getPosition() override;

        virtual gep::Quaternion getRotation() override;
        
        void lookAt(const gep::vec3& target);

        void setViewDirection(const gep::vec3& vector);

        void setActive();

        float getViewAngle() const {return m_pCamera->getViewAngle();}

        void setViewAngle(float angle){m_pCamera->setViewAngle(angle);}

        void tilt(float amount){m_pCamera->tilt(amount);}

        void move(const gep::vec3& delta);

        void look(const gep::vec2& delta);

        void setNear(float nearValue){m_pCamera->setNear(nearValue);}

        float getNear(){return m_pCamera->getNear();}

        void setFar(float farValue){m_pCamera->setFar(farValue);}

        float getFar(){return m_pCamera->getFar();}

        float getAspectRatio(){return m_pCamera->getAspectRatio();}

        void setAspectRatio(float ratio){m_pCamera->setAspectRatio(ratio);}


        virtual gep::vec3 getRightDirection() override;
        virtual gep::vec3 getUpDirection() override;
        virtual gep::vec3 getViewDirection() override;
        virtual gep::vec3 getScale() override;
        virtual gep::mat4 getTransformationMatrix() override;
        virtual void setBaseViewDirection(const gep::vec3& direction) override;
        virtual void setBaseOrientation(const gep::Quaternion& orientation) override;
        virtual void setScale(const gep::vec3& scale) override;


        virtual void setState(State::Enum state) override;
    
        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION(setPosition)
            LUA_BIND_FUNCTION(lookAt)
            LUA_BIND_FUNCTION(setViewDirection)
            LUA_BIND_FUNCTION(getRightDirection)
            LUA_BIND_FUNCTION(getUpDirection)
            LUA_BIND_FUNCTION(getViewDirection)
            LUA_BIND_FUNCTION(getPosition)
            LUA_BIND_FUNCTION(getRotation)
            LUA_BIND_FUNCTION(setRotation)
            LUA_BIND_FUNCTION(setBaseOrientation)
            LUA_BIND_FUNCTION(setBaseViewDirection)
            LUA_BIND_FUNCTION(setState)
            LUA_BIND_FUNCTION(getViewAngle)
            LUA_BIND_FUNCTION(setViewAngle)
            LUA_BIND_FUNCTION(tilt)
            LUA_BIND_FUNCTION(move)
            LUA_BIND_FUNCTION(look)
            LUA_BIND_FUNCTION(setNear)
            LUA_BIND_FUNCTION(getNear)
            LUA_BIND_FUNCTION(setFar)
            LUA_BIND_FUNCTION(getFar)
            LUA_BIND_FUNCTION(setAspectRatio)
            LUA_BIND_FUNCTION(getAspectRatio)
        LUA_BIND_REFERENCE_TYPE_END 

    private:
        gep::CameraLookAtHorizon* m_pCamera;
        gep::Quaternion m_baseOrientation;
        gep::vec3 m_lookAt;

    };

    template<>
    struct ComponentMetaInfo<CameraComponent>
    {
        static const char* name(){ return "CameraComponent"; }
        static const int priority(){ return 23; }
        static CameraComponent* create(){ return new CameraComponent(); }
    };
}

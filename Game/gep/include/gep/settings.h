#pragma once

#include "gep/math3d/vec2.h"
#include "gep/math3d/color.h"

#include "gep/interfaces/scripting.h"

namespace gep
{
    namespace settings
    {
        struct Video
        {
            uvec2 screenResolution;
            bool vsyncEnabled;
            Color clearColor;

            Video() :
                screenResolution(1280, 720),
                vsyncEnabled(true),
                clearColor(0.0f, 0.125f, 0.3f, 1.0f)
            {
            }
        };

        struct Lua
        {
            size_t maxStackDumpLevel;
            bool callstackTracebackEnabled;
            bool stackDumpEnabled;

            Lua() :
                maxStackDumpLevel(2),
#ifdef _DEBUG
                callstackTracebackEnabled(true),
                stackDumpEnabled(true)
#else
                callstackTracebackEnabled(false),
                stackDumpEnabled(false)
#endif // _DEBUG

            {
            }
        };
    }

    // Can be set in scripts
    class ISettings
    {
    public:
        ISettings() {}
        virtual ~ISettings() {}

        virtual void setVideoSettings(const settings::Video& settings) = 0;
        virtual       settings::Video& getVideoSettings() = 0;
        virtual const settings::Video& getVideoSettings() const = 0;

        virtual void setLuaSettings(const settings::Lua& settings) = 0;
        virtual       settings::Lua& getLuaSettings() = 0;
        virtual const settings::Lua& getLuaSettings() const = 0;

        virtual void loadFromScriptTable(ScriptTableWrapper table) = 0;

        LUA_BIND_REFERENCE_TYPE_BEGIN
            LUA_BIND_FUNCTION_NAMED(loadFromScriptTable, "load")
        LUA_BIND_REFERENCE_TYPE_END
    };
}

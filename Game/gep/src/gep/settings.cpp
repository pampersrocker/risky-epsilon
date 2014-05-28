#include "stdafx.h"
#include "gepimpl/settings.h"



gep::Settings::Settings() :
    m_video()
{
}

gep::Settings::~Settings()
{
}

void gep::Settings::loadFromScriptTable(ScriptTableWrapper table)
{
    {
        // Get inner table "video" in table "table", i.e. "table.video"
        ScriptTableWrapper videoSettings;
        table.tryGet("video", videoSettings);

        // Extract the settings
        videoSettings.tryGet("screenResolution", m_video.screenResolution);
        videoSettings.tryGet("vsyncEnabled", m_video.vsyncEnabled);
    }
    {
        // Get inner table "lua" in table "table", i.e. "table.lua"
        ScriptTableWrapper luaSettings;
        table.tryGet("lua", luaSettings);

        // Extract the settings
        luaSettings.tryGet("maxStackDumpLevel", m_lua.maxStackDumpLevel);
    }
}

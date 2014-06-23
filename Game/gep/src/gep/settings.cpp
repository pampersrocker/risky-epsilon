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
    /// Load settings from the argument 'table' like this:
    /// ScriptTableWrapper innerTable;
    /// table.tryGet("myInnerTableNameInLua", innerTable);
    /// int theSetting = 42;
    /// innerTable.tryGet("mySetting", theSetting);
    /// // Now you can use theSetting!

    {
        // Get inner table.
        ScriptTableWrapper videoSettings;
        table.tryGet("video", videoSettings);

        // Extract the settings
        videoSettings.tryGet("screenResolution", m_video.screenResolution);
        videoSettings.tryGet("vsyncEnabled", m_video.vsyncEnabled);
        videoSettings.tryGet("clearColor", m_video.clearColor);
    }

    // NOTE: Make sure to load lua settings last!
    {
        // Get inner table.
        ScriptTableWrapper luaSettings;
        table.tryGet("lua", luaSettings);

        // Extract the settings
        luaSettings.tryGet("maxStackDumpLevel", m_lua.maxStackDumpLevel);
        luaSettings.tryGet("callstackTracebackEnabled", m_lua.callstackTracebackEnabled);
        luaSettings.tryGet("stackDumpEnabled", m_lua.stackDumpEnabled);
    }
}

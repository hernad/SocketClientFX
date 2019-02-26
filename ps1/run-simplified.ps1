Set-variable -Name CMDLINE_ARGS -Value $args

& {      
    #
    # Move to the directory containing this script so we can source the env.ps1
    # properties that follow
    #
    cd $PSScriptRoot
    
    #
    # Common properties shared by scripts
    #
    . .\env.ps1
    
    #
    # Create a module-path for the java command.  It includes $TARGET/$MAINJAR
    # and the $EXTERNAL_MODULES defined in env.ps1.
    #
    Set-Variable -Name MODPATH -Value $TARGET\$MAINJAR 
    ForEach ($i in $EXTERNAL_MODULES) {
       $MODPATH += ";"
       $MODPATH += $i
    }
    
    #
    # Have to manually specify main class via jar --update until
    # maven-jar-plugin 3.1.2+ is released
    Write-Output ""
    Write-Output "Did you run 'mvn jar:jar' first?"
    Write-Output ""
    Set-Variable -Name JAR_ARGS -Value @(
        "--main-class",
        """$MAINCLASS""",
        "--update",
        "--file",
        """$TARGET\$MAINJAR"""
    )
    Exec-Cmd("jar.exe", $JAR_ARGS)
    
    #
    # Run the Java command
    #
    Set-Variable -Name JAVA_ARGS -Value @(
        "--module-path",
        """$MODPATH""",
        "-m",
        """$MAINMODULE"""
    )
    Exec-Cmd("java.exe", $JAVA_ARGS)
}
QT *= xml opengl widgets gui

CONFIG += qt opengl warn_on thread rtti console embed_manifest_exe no_keywords

# Set path to include and lib files (see doc/compilation.html for details):
# Uncomment and tune these paths according to your configuration.

#INCLUDEPATH *= C:/Users/debunne/Documents/libQGLViewer-VERSION
#LIBS *= -LC:/Users/debunne/Documents/libQGLViewer-VERSION/QGLViewer -lQGLViewer2

# --------------------------------------------------------------------------------------

# The rest of this file sets these paths so that the examples
# can be compiled out of the box

ROOT_DIRECTORY = ../..

contains( _PRO_FILE_PWD_, ".*designerPlugin$" ) {
	ROOT_DIRECTORY = ..
}
contains( _PRO_FILE_PWD_, ".*/contribs/.+/.+" ) {
	ROOT_DIRECTORY = ../../../..
} else {	
	contains( _PRO_FILE_PWD_, ".*/contribs/.+" ) {
		ROOT_DIRECTORY = ../../..
	}
}

INCLUDE_DIR = $${ROOT_DIRECTORY}
LIB_DIR = $${ROOT_DIRECTORY}/QGLViewer

# Include path, taking QGLViewer path prefix into account
INCLUDEPATH *= $${INCLUDE_DIR}
DEPENDPATH  *= $${INCLUDE_DIR}

unix {
	CONFIG -= debug debug_and_release
	CONFIG *= release

	isEmpty( QGLVIEWER_STATIC ) {
		# The absolute path where the library or framework was found
		LIB_DIR_ABSOLUTE_PATH = $$dirname(PWD)/QGLViewer
		
		macx|darwin-g++ {
			# Use install_name_tool to set the absolute path of the lib in the executable
			exists( $${LIB_DIR_ABSOLUTE_PATH}/QGLViewer.framework ) {
				!plugin:QMAKE_POST_LINK=install_name_tool -change QGLViewer.framework/Versions/2/QGLViewer $${LIB_DIR_ABSOLUTE_PATH}/QGLViewer.framework/Versions/2/QGLViewer $${TARGET}.app/Contents/MacOS/$${TARGET} #VERSION_MAJOR
				LIBS += -F$${LIB_DIR_ABSOLUTE_PATH} -framework QGLViewer
			} else {
				!plugin:QMAKE_POST_LINK=install_name_tool -change libQGLViewer.2.dylib $${LIB_DIR_ABSOLUTE_PATH}/libQGLViewer.2.dylib $${TARGET}.app/Contents/MacOS/$${TARGET} #VERSION_MAJOR
				LIBS *= -L$${LIB_DIR} -lQGLViewer
			}
		} else {
			isEmpty(QMAKE_LFLAGS_RPATH) {
				!plugin:QMAKE_LFLAGS += -Wl,-rpath,$${LIB_DIR_ABSOLUTE_PATH}
			} else {
				!plugin:QMAKE_RPATHDIR *= $${LIB_DIR_ABSOLUTE_PATH}
			}
			LIBS *= -L$${LIB_DIR} -lQGLViewer
		}
	} else {
		LIBS *= $${LIB_DIR}/libQGLViewer.a
	}

	# Intermediate files are created in hidden folders
	MOC_DIR = .moc
	OBJECTS_DIR = .obj
}


win32 {
	CONFIG *= debug_and_release

	# Seems to be needed for Visual Studio with Intel compiler
	DEFINES *= WIN32

	isEmpty( QGLVIEWER_STATIC ) {
		LIBS *= -L$${LIB_DIR} -lQGLViewer2
	} else {
		DEFINES *= QGLVIEWER_STATIC
		LIBS *= $${LIB_DIR}/libQGLViewer2.a
	}
}



# Application icon
macx|darwin-g++ {
	ICON = $${ROOT_DIRECTORY}/QGLViewer/qglviewer.icns
}

win32 {
	!designer {
		exists( $${ROOT_DIRECTORY}/examples/qglviewer.rc ) {
			RC_FILE = $${ROOT_DIRECTORY}/examples/qglviewer.rc
		}
	}
}

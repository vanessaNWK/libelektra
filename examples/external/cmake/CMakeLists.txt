cmake_minimum_required(VERSION 2.6)

# you might need to change CMAKE_MODULE_PATH
# can also be done with ccmake
#set (CUSTOM_MODULE_PATH "/opt/local/share/cmake-2.8/Modules")
#set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CUSTOM_MODULE_PATH})

find_package(Elektra REQUIRED)

if (ELEKTRA_FOUND)
	message (STATUS "Elektra ${ELEKTRA_VERSION} found")
	include_directories (${ELEKTRA_INCLUDE_DIR})

	add_executable (application application.c)
	target_link_libraries (application ${ELEKTRA_LIBRARIES})
else (ELEKTRA_FOUND)
	message (FATAL_ERROR "Elektra not found")
endif(ELEKTRA_FOUND)

#
#   tool.make
#
#   Makefile rules to build GNUstep-based command line tools.
#
#   Copyright (C) 1997 Free Software Foundation, Inc.
#
#   Author:  Scott Christley <scottc@net-community.com>
#
#   This file is part of the GNUstep Makefile Package.
#
#   This library is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License
#   as published by the Free Software Foundation; either version 2
#   of the License, or (at your option) any later version.
#   
#   You should have received a copy of the GNU General Public
#   License along with this library; see the file COPYING.LIB.
#   If not, write to the Free Software Foundation,
#   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#
# The name of the tools is in the TOOL_NAME variable.
#
# xxx We need to prefix the target name when cross-compiling
#

#
# Include in the common makefile rules
#
include $(GNUSTEP_SYSTEM_ROOT)/Makefiles/rules.make

ifeq ($(INTERNAL_tool_NAME),)

internal-all:: $(TOOL_NAME:=.all.tool.variables)

internal-install:: $(TOOL_NAME:=.install.tool.variables)

internal-uninstall:: $(TOOL_NAME:=.uninstall.tool.variables)

internal-clean:: $(TOOL_NAME:=.clean.tool.variables)

internal-distclean:: $(TOOL_NAME:=.distclean.tool.variables)

$(TOOL_NAME):
	@$(MAKE) --no-print-directory $@.all.tool.variables

else

# This is the directory where the tools get installed. If you don't specify a
# directory they will get installed in the GNUstep system root.
TOOL_INSTALLATION_DIR = \
    $(GNUSTEP_INSTALLATION_DIR)/Tools/$(GNUSTEP_TARGET_DIR)/$(LIBRARY_COMBO)

ALL_TOOL_LIBS = $(ADDITIONAL_TOOL_LIBS) $(AUXILIARY_TOOL_LIBS) $(FND_LIBS) \
   $(ADDITIONAL_OBJC_LIBS) $(AUXILIARY_OBJC_LIBS) $(OBJC_LIBS) \
   $(TARGET_SYSTEM_LIBS)

ALL_TOOL_LIBS := \
    $(shell $(WHICH_LIB_SCRIPT) $(LIB_DIRS_NO_SYSTEM) $(ALL_TOOL_LIBS) \
	debug=$(debug) profile=$(profile) shared=$(shared) libext=$(LIBEXT) \
	shared_libext=$(SHARED_LIBEXT))

#
# Compilation targets
#
internal-tool-all:: before-$(TARGET)-all $(GNUSTEP_OBJ_DIR) \
	$(GNUSTEP_OBJ_DIR)/$(INTERNAL_tool_NAME) after-$(TARGET)-all

$(GNUSTEP_OBJ_DIR)/$(INTERNAL_tool_NAME): $(C_OBJ_FILES) $(OBJC_OBJ_FILES)
	$(LD) $(ALL_LDFLAGS) $(LDOUT)$@ \
		$(C_OBJ_FILES) $(OBJC_OBJ_FILES) \
		$(ALL_LIB_DIRS) $(ALL_TOOL_LIBS)

before-$(TARGET)-all::

after-$(TARGET)-all::

internal-tool-install:: internal-install-dirs install-tool

internal-install-dirs::
	$(GNUSTEP_MAKEFILES)/mkinstalldirs $(TOOL_INSTALLATION_DIR)

install-tool::
	$(INSTALL_PROGRAM) -m 0755 $(INTERNAL_tool_NAME) \
	    $(TOOL_INSTALLATION_DIR);

internal-tool-uninstall::
	rm -f $(TOOL_INSTALLATION_DIR)/$(INTERNAL_tool_NAME)

#
# Cleaning targets
#
internal-tool-clean::
	rm -rf $(GNUSTEP_OBJ_DIR)

internal-tool-distclean::
	rm -rf shared_obj static_obj shared_debug_obj shared_profile_obj \
	  static_debug_obj static_profile_obj shared_profile_debug_obj \
	  static_profile_debug_obj

endif

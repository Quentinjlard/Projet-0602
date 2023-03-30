#
# MAIN CONFIGURATION
#

EXEC = lecteur_level
ANALYSER = lecteur_level
OBJECTS = lex.yy.o y.tab.o level.o block.o symbol.o symbol_lst.o symbol_table.o instructions.o instructions_lst.o
PROJECT_NAME = lecteur_level


#
# SUFFIXES
#

.SUFFIXES: .c .o

#
# OBJECTS
#

EXEC_O = $(EXEC:=.o)
OBJECTS_O = $(OBJECTS) $(EXEC_O)

#
# ARGUMENTS AND COMPILER
# -Werror

CC = gcc
CCFLAGS_STD = -Wall 
CCFLAGS_DEBUG = -D _DEBUG_
CCFLAGS = $(CCFLAGS_STD)
CCLIBS = -lfl
YACCFLAGS = -d

#
# RULES
#

all: msg $(OBJECTS) $(EXEC_O)
	@echo "Create executables..."
	@for i in $(EXEC); do \
	$(CC) -o $$i $$i.o $(OBJECTS) $(CCLIBS); \
	done
	@echo "Done."

msg:
	@echo "Create objects..."

debug: CCFLAGS = $(CCFLAGS_STD) $(CCFLAGS_DEBUG)
debug: all

#
# DEFAULT RULES
#

%.o : %.c
	@cd $(dir $<) && ${CC} ${CCFLAGS} -c $(notdir $<) -o $(notdir $@)

lex.yy.c : $(ANALYSER).lex y.tab.h
	@flex $(ANALYSER).lex

y.tab.c y.tab.h : $(ANALYSER).yacc.y
	@yacc ${YACCFLAGS} $(ANALYSER).yacc.y

#
# GENERAL RULES
#

clean:
	@echo "Delete objects, temporary files..."
	@rm -f $(OBJECTS) $(EXEC_O)
	@rm -f *~ *#
	@rm -f $(EXEC)
	@rm -f dependancies
	@rm -f y.tab.* lex.yy.* y.output
	@echo "Done."

depend:
	@echo "Create dependancies..."
	@sed -e "/^# DEPENDANCIES/,$$ d" makefile > dependancies
	@echo "# DEPENDANCIES" >> dependancies
	@for i in $(OBJECTS_O); do \
	$(CC) -MM -MT $$i $(CCFLAGS) `echo $$i | sed "s/\(.*\)\\.o$$/\1.c/"` >> dependancies; \
	done
	@cat dependancies > makefile
	@rm dependancies
	@echo "Done."

#
# CREATE ARCHIVE
#

ARCHIVE_FILES = *

archive: clean
	@echo "Create archive $(PROJECT_NAME)_$(shell date '+%y%m%d.tar.gz')..."
	@REP=`basename "$$PWD"`; cd .. && tar zcf $(PROJECT_NAME)_$(shell date '+%y%m%d.tar.gz') $(addprefix "$$REP"/,$(ARCHIVE_FILES))
	@echo "Done."

# DEPENDANCIES
lex.yy.o: lex.yy.c instructions_lst.h instructions.h symbol.h block.h \
 symbol_table.h symbol_lst.h level.h y.tab.h
y.tab.o: y.tab.c instructions_lst.h instructions.h symbol.h block.h \
 symbol_table.h symbol_lst.h level.h y.tab.h
level.o: level.c block.h level.h
block.o: block.c block.h level.h
symbol.o: symbol.c symbol.h
symbol_lst.o: symbol_lst.c symbol_lst.h symbol.h
symbol_table.o: symbol_table.c symbol_table.h symbol_lst.h symbol.h
instructions.o: instructions.c instructions.h symbol.h block.h
instructions_lst.o: instructions_lst.c instructions_lst.h instructions.h \
 symbol.h block.h
lecteur_level.o: lecteur_level.c block.h level.h

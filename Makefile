TARGET     = corr_learn_net
MAJOR      = 1
MINOR      = 0.0

CC         = gcc
WARNINGS   = -Wextra

INCLUDES   = -Iinc
LIBS       = -lm -lrt

VERSION    = ${MAJOR}.${MINOR}
CPPFLAGS   = -DVERSION=\"${VERSION}\"
CFLAGS     = -std=gnu99 ${INCLUDES} ${WARNINGS} ${CPPFLAGS}
LDFLAGS    = ${LIBS}

CFLAGS_DBG = -DDEBUG -ggdb
CFLAGS_RLS = -DNDEBUG -O3 -ffast-math

SRCDIR     = src
SRCEXT     = c
SRC        = $(shell find $(SRCDIR) -name \*.$(SRCEXT) -type f -print)

BUILDDIR   = build
OBJDIR_DBG = ${BUILDDIR}/debug
OBJDIR_RLS = ${BUILDDIR}/release
OBJ_DBG    = $(patsubst $(SRCDIR)/%,$(OBJDIR_DBG)/%,$(patsubst %.$(SRCEXT),%.o,$(SRC)))
OBJ_RLS    = $(patsubst $(SRCDIR)/%,$(OBJDIR_RLS)/%,$(patsubst %.$(SRCEXT),%.o,$(SRC)))
DIRTREE_DBG= $(OBJDIR_DBG) \
	     $(patsubst $(SRCDIR)/%,$(OBJDIR_DBG)/%,\
	     $(shell find $(SRCDIR)/* -type d -print))
DIRTREE_RLS= $(OBJDIR_RLS) \
	     $(patsubst $(SRCDIR)/%,$(OBJDIR_RLS)/%,\
	     $(shell find $(SRCDIR)/* -type d -print))

all: debug

release: makedirs ${OBJ_RLS}
	@echo ' [LD] '${TARGET}
	@${CC} ${OBJ_RLS} ${LDFLAGS} -o ${TARGET}

debug: makedirs ${OBJ_DBG}
	@echo ' [LD] '${TARGET}
	@${CC} ${OBJ_DBG} ${LDFLAGS} -o ${TARGET}

-include ${OBJ_DBG:.o=.d}

${OBJDIR_DBG}/%.o: ${SRCDIR}/%.$(SRCEXT)
	@echo ' [CC] '$<
	@${CC} ${CFLAGS} ${CFLAGS_DBG} -c -o $@ $<
	@${CC} ${CFLAGS} ${CFLAGS_DBG} -MM $< > $(patsubst %.o,%.d,$@)

${OBJDIR_RLS}/%.o: ${SRCDIR}/%.$(SRCEXT)
	@echo ' [CC] '$<
	@${CC} ${CFLAGS} ${CFLAGS_RLS} -c -o $@ $<
	@${CC} ${CFLAGS} ${CFLAGS_RLS} \
		-MM $< > $(patsubst $(OBJDIR_RLS)/%,$(OBJDIR_DBG)/%,\
			$(patsubst %.o,%.d,$@))

makedirs:
	@mkdir -p ${DIRTREE_DBG}
	@mkdir -p ${DIRTREE_RLS}

clean:
	@rm -rf ${BUILDDIR}
	@rm -f ${TARGET}

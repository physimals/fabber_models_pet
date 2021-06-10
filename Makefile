include ${FSLCONFDIR}/default.mk

PROJNAME = fabber_pet

LIBS = -lfsl-fabberexec -lfsl-fabbercore -lfsl-newimage \
       -lfsl-miscmaths -lfsl-cprob -lfsl-utils \
       -lfsl-NewNifti -lfsl-znz -lz -ldl

XFILES  = fabber_pet
SOFILES = libfsl-fabber_models_pet.so

# Forward models
OBJS =  fwdmodel_pet.o fwdmodel_pet_1TCM.o

# For debugging:
#OPTFLAGS = -ggdb

# Pass Git revision details
GIT_SHA1:=$(shell git describe --match=NeVeRmAtCh --always --abbrev=40 --dirty)
GIT_DATE:=$(shell git log -1 --format=%ad --date=local)
CXXFLAGS += -DGIT_SHA1=\"${GIT_SHA1}\" -DGIT_DATE="\"${GIT_DATE}\""

#
# Build
#

all:	${XFILES} ${SOFILES}

# models in a library
libfsl-fabber_models_pet.so : ${OBJS}
	${CXX} ${CXXFLAGS} -shared -o $@ $^ ${LDFLAGS}

# fabber built from the FSL fabbercore library including the models specifieid in this project
fabber_pet : fabber_client.o libfsl-fabber_models_pet.so
	${CXX} ${CXXFLAGS} -o $@ $< -lfsl-fabber_models_pet ${LDFLAGS}

# DO NOT DELETE

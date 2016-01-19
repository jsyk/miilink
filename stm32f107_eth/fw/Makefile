###############################################################################
TRGT = arm-none-eabi-
CC      = $(TRGT)gcc
LD      = $(TRGT)gcc
AR      = $(TRGT)ar
AS      = $(TRGT)gcc
CP      = $(TRGT)objcopy
OD		= $(TRGT)objdump
###############################################################################
# List all default C defines here
DDEFS = -DSTM32F10X_CL -DUSE_STDPERIPH_DRIVER -DHSE_VALUE=50000000

# List all default ASM defines here
DADEFS = -D__FLASH_BUILD

# List all default directories to look for include files here
DINCDIR = 

# List the default directory to look for the libraries here
DLIBDIR =

# List all default libraries here
DLIBS = 

# Path to FreeRTOS sources
FREERTOS = FreeRTOS/Source

###############################################################################
NAME   		= stm32frtos1
CPU			= cortex-m3
PRJDIR		= prj
###############################################################################
SRC = main.c eth.c \
	Drivers/STM32_USART.c \
	$(FREERTOS)/portable/GCC/ARM_CM3/port.c \
	$(FREERTOS)/tasks.c \
	$(FREERTOS)/list.c \
	$(FREERTOS)/queue.c \
	$(FREERTOS)/timers.c \
	$(FREERTOS)/portable/MemMang/heap_2.c \
 	ST_Library/src/stm32f10x_gpio.c \
 	ST_Library/src/stm32f10x_rcc.c \
 	ST_Library/src/stm32f10x_spi.c \
 	ST_Library/src/stm32f10x_usart.c \
 	ST_Library/src/stm32f10x_can.c \
 	ST_Library/src/stm32f10x_i2c.c \
 	ST_Library/src/stm32f10x_flash.c \
 	ST_Library/src/system_stm32f10x.c \
 	ST_Library/src/misc.c \
 	STM32_ETH_Driver/src/stm32_eth.c

 	#ST_Library/src/stm32f10x_lib.c
 	# ST_Library/src/stm32f10x_systick.c \
 	# ST_Library/src/stm32f10x_nvic.c \
	# ../Common/Minimal/recmutex.c \
	# ../Common/Minimal/semtest.c \
	# ../Common/Minimal/BlockQ.c \
	# ../Common/Minimal/GenQTest.c \
	# ../Common/Minimal/integer.c \
	# ../Common/Minimal/PollQ.c \
	# ../Common/Minimal/QPeek.c \

###############################################################################
ASRC = STM32F10x_Startup.s
###############################################################################
# List all user directories here
UINCDIR = ./ $(FREERTOS)/include $(FREERTOS)/portable/GCC/ARM_CM3 ST_Library/inc STM32_ETH_Driver/inc ../Common/include Drivers
# List the user directory to look for the libraries here
ULIBDIR =
# List all user libraries here
ULIBS = 
###############################################################################
LDSCR = stm32_flash.ld
###############################################################################
INCDIR  = $(patsubst %,-I%,$(DINCDIR) $(UINCDIR))
LIBDIR  = $(patsubst %,-L%,$(DLIBDIR) $(ULIBDIR))

ADEFS   = $(DADEFS) $(UADEFS)
DEFS    = $(DDEFS) $(UDEFS)
LIBS    = $(DLIBS) $(ULIBS)

IMM0 = $(ASRC:.s=.o)
IMM1 = $(IMM0:.S=.O)
IMM2 = $(SRC:.c=.o)
IMM3 = $(IMM2:.C=.O)
OBJ  = $(IMM1) $(IMM3)
#OBJ  = $(IMM1) $(IMM3)
IMM2SPI = $(SRCSPI:.c=.o)
IMM3SPI = $(IMM2SPI:.C=.O)
OBJSPI  = $(IMM1) $(IMM3SPI)

IMM2UC4 = $(SRCUC4:.c=.o)
IMM3UC4 = $(IMM2UC4:.C=.O)
OBJUC4  = $(IMM1) $(IMM3UC4)

CFLAGS  = -c -O3 -g3 -std=c99 -Wall -mcpu=$(CPU) -mthumb -mtune=$(CPU) -ffunction-sections $(INCDIR) $(LIBDIR)  $(DEFS)
#-Wc++-compat
ASFLAGS = -mcpu=$(CPU) -mthumb -g3 -x assembler-with-cpp -c -ffunction-sections $(ADEFS)
LFLAGS  = -nostartfiles -mcpu=$(CPU) -mthumb -mtune=$(CPU) -Wl,--gc-sections 
CPFLAGS = -Obinary
ODFLAGS	= -S
# -D

CFLAGS += -mno-long-calls

# all:				$(NAME)_ram.lst $(NAME)_ram.bin $(NAME)_flash.lst $(NAME)_flash.bin

all:				$(NAME)_flash.lst $(NAME)_flash.bin

%o: 				%c
					$(CC) -c $(CFLAGS) -I . $(INCDIR) $< -o $@

%O: 				%C
					$(CC) -c $(CFLAGS) -I . $(INCDIR) $< -o $@

%o: 				%s
					$(AS) -c $(ASFLAGS) -I . $(INCDIR) $< -o $@

%O: 				%S
					$(AS) -c $(ASFLAGS) -I . $(INCDIR) $< -o $@

$(NAME)_flash.lst:	$(NAME)_flash.elf
					$(OD) $(ODFLAGS) $< > $@

$(NAME)_ram.lst:	$(NAME)_ram.elf
					$(OD) $(ODFLAGS) $< > $@

$(NAME)_flash.bin:	$(NAME)_flash.elf
					$(CP) $(CPFLAGS) $< $@

$(NAME)_ram.bin:	$(NAME)_ram.elf
					$(CP) $(CPFLAGS) $< $@

$(NAME)_flash.elf:	$(OBJ) 
	$(LD) $(DEBUG_GDB) $(LFLAGS) -T $(LDSCR) -o $(NAME)_flash.elf $(OBJ) $(LIBS)
	$(TRGT)size $@

# $(NAME)_ram.elf:	$(OBJ) 
# 	$(LD) $(DEBUG_GDB) $(LFLAGS) -T $(PRJDIR)\linker_ram.ld -o $(NAME)_ram.elf $(OBJ) $(LIBS)
# 	$(TRGT)size $@

# spitest_ram.elf:	$(OBJSPI) 
# 	$(LD) $(DEBUG_GDB) $(LFLAGS) -T $(PRJDIR)\linker_ram.ld -o $@ $(OBJSPI) $(LIBS)
# 	$(TRGT)size $@


clean:
	rm -f $(OBJ) $(OBJUC4)
	rm -f $(NAME)_flash.elf $(NAME)_flash.lst  $(NAME)_flash.bin

stflash: $(NAME)_flash.bin
	st-flash write $(NAME)_flash.bin 0x08000000

ocdserver:
	openocd -f interface/stlink-v2.cfg -f target/stm32f1x_stlink.cfg -c "init" -c "halt" -c "reset halt"

ocdgdb: $(NAME)_flash.elf
	arm-none-eabi-gdb --eval-command="target remote localhost:3333" $(NAME)_flash.elf

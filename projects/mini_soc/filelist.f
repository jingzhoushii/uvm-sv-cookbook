# Mini SoC UVM Testbench File List

# RTL
rtl/top.sv
rtl/bus/system_bus.sv
rtl/cpu_stub/cpu_stub.sv
rtl/dma/dma_controller.sv
rtl/uart/uart.sv
rtl/timer/timer.sv

# Interface
tb/agent/bus_agent/bus_agent.sv
tb/agent/uart_agent/uart_agent.sv
tb/agent/dma_agent/dma_agent.sv

# Environment
tb/env/mini_soc_env_cfg.sv
tb/env/mini_soc_env.sv

# Virtual Sequences
tb/virt_seq/base_vseq.sv
tb/virt_seq/boot_vseq.sv
tb/virt_seq/stress_vseq.sv

# Tests
tb/test/base_test.sv
tb/test/smoke_test.sv
tb/test/stress_test.sv

# Top
tb/tb_top.sv

# Reference Model
reg/ref_model.sv

# Enhanced Virtual Sequences
tb/virt_seq/system_vseq.sv
tb/virt_seq/concurrent_vseq.sv
tb/virt_seq/boot_vseq_enh.sv

# System Tests
tb/test/system_test.sv
tb/test/concurrent_test.sv
tb/test/boot_enh_test.sv

# Phase A: Platform Configuration
tb/env/mini_soc_platform_cfg.sv
tb/env/mini_soc_platform_env.sv
tb/env/reg_checker.sv

# Phase B: Virtual Sequences
tb/virt_seq/boot/power_on_vseq.sv
tb/virt_seq/boot/reset_recovery_vseq.sv
tb/virt_seq/traffic/dma_flood_vseq.sv
tb/virt_seq/traffic/uart_stream_vseq.sv
tb/virt_seq/traffic/mixed_io_vseq.sv
tb/virt_seq/error/bus_error_vseq.sv
tb/virt_seq/chaos/random_system_vseq.sv

# Phase C: Reference Model
ref/bus_model/bus_ref_model.sv
ref/memory_model/memory_ref_model.sv
ref/uart_model/uart_ref_model.sv
ref/dma_model/dma_ref_model.sv
ref/soc_ref_model.sv

# Phase D: Scoreboard
tb/env/soc_sb_enhanced.sv

# Phase E: Coverage
coverage/soc_coverage分层.sv

# Phase F: Regression
regress/regress_industrial.yaml
regress/run_industrial.py

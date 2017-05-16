`timescale 1ns / 1ps

module scalar(
    input clk,
    input acc_clk,
    //control interface
    input [31:0] scalar_read_addr,
    input scalar_re,
    output [31:0] scalar_dout,
    input scalar_we,
    input [31:0] scalar_write_addr,
    input [31:0] scalar_din,
    input outscalar_capture,
    input [C_NUM_INSCALARS-1:0] inscalar_next,
    output [C_NUM_INSCALARS-1:0] inscalar_fifo_empty,
    output [C_NUM_INSCALARS-1:0] inscalar_fifo_full,
    output [C_NUM_OUTSCALARS-1:0] outscalar_fifo_empty,
    output [C_NUM_OUTSCALARS-1:0] outscalar_fifo_full,
    output [C_NUM_OUTSCALARS-1:0] outscalar_null_empty,
    output [C_NUM_OUTSCALARS-1:0] outscalar_null_dout,
    input [C_NUM_OUTSCALARS-1:0] outscalar_null_read,
    //input scalar ports
    output [C_INSCALAR_0_BITS-1:0] inscalar0,
    output [C_INSCALAR_1_BITS-1:0] inscalar1,
    output [C_INSCALAR_2_BITS-1:0] inscalar2,
    output [C_INSCALAR_3_BITS-1:0] inscalar3,
    output [C_INSCALAR_4_BITS-1:0] inscalar4,
    output [C_INSCALAR_5_BITS-1:0] inscalar5,
    output [C_INSCALAR_6_BITS-1:0] inscalar6,
    output [C_INSCALAR_7_BITS-1:0] inscalar7,
    output [C_INSCALAR_8_BITS-1:0] inscalar8,
    output [C_INSCALAR_9_BITS-1:0] inscalar9,
    output [C_INSCALAR_10_BITS-1:0] inscalar10,
    output [C_INSCALAR_11_BITS-1:0] inscalar11,
    output [C_INSCALAR_12_BITS-1:0] inscalar12,
    output [C_INSCALAR_13_BITS-1:0] inscalar13,
    output [C_INSCALAR_14_BITS-1:0] inscalar14,
    output [C_INSCALAR_15_BITS-1:0] inscalar15,
    output [C_INSCALAR_16_BITS-1:0] inscalar16,
    output [C_INSCALAR_17_BITS-1:0] inscalar17,
    output [C_INSCALAR_18_BITS-1:0] inscalar18,
    output [C_INSCALAR_19_BITS-1:0] inscalar19,
    output [C_INSCALAR_20_BITS-1:0] inscalar20,
    output [C_INSCALAR_21_BITS-1:0] inscalar21,
    output [C_INSCALAR_22_BITS-1:0] inscalar22,
    output [C_INSCALAR_23_BITS-1:0] inscalar23,
    output [C_INSCALAR_24_BITS-1:0] inscalar24,
    output [C_INSCALAR_25_BITS-1:0] inscalar25,
    output [C_INSCALAR_26_BITS-1:0] inscalar26,
    output [C_INSCALAR_27_BITS-1:0] inscalar27,
    output [C_INSCALAR_28_BITS-1:0] inscalar28,
    output [C_INSCALAR_29_BITS-1:0] inscalar29,
    output [C_INSCALAR_30_BITS-1:0] inscalar30,
    output [C_INSCALAR_31_BITS-1:0] inscalar31,
    output [C_INSCALAR_32_BITS-1:0] inscalar32,
    output [C_INSCALAR_33_BITS-1:0] inscalar33,
    output [C_INSCALAR_34_BITS-1:0] inscalar34,
    output [C_INSCALAR_35_BITS-1:0] inscalar35,
    output [C_INSCALAR_36_BITS-1:0] inscalar36,
    output [C_INSCALAR_37_BITS-1:0] inscalar37,
    output [C_INSCALAR_38_BITS-1:0] inscalar38,
    output [C_INSCALAR_39_BITS-1:0] inscalar39,
    output [C_INSCALAR_40_BITS-1:0] inscalar40,
    output [C_INSCALAR_41_BITS-1:0] inscalar41,
    output [C_INSCALAR_42_BITS-1:0] inscalar42,
    output [C_INSCALAR_43_BITS-1:0] inscalar43,
    output [C_INSCALAR_44_BITS-1:0] inscalar44,
    output [C_INSCALAR_45_BITS-1:0] inscalar45,
    output [C_INSCALAR_46_BITS-1:0] inscalar46,
    output [C_INSCALAR_47_BITS-1:0] inscalar47,
    output [C_INSCALAR_48_BITS-1:0] inscalar48,
    output [C_INSCALAR_49_BITS-1:0] inscalar49,
    output [C_INSCALAR_50_BITS-1:0] inscalar50,
    output [C_INSCALAR_51_BITS-1:0] inscalar51,
    output [C_INSCALAR_52_BITS-1:0] inscalar52,
    output [C_INSCALAR_53_BITS-1:0] inscalar53,
    output [C_INSCALAR_54_BITS-1:0] inscalar54,
    output [C_INSCALAR_55_BITS-1:0] inscalar55,
    output [C_INSCALAR_56_BITS-1:0] inscalar56,
    output [C_INSCALAR_57_BITS-1:0] inscalar57,
    output [C_INSCALAR_58_BITS-1:0] inscalar58,
    output [C_INSCALAR_59_BITS-1:0] inscalar59,
    output [C_INSCALAR_60_BITS-1:0] inscalar60,
    output [C_INSCALAR_61_BITS-1:0] inscalar61,
    output [C_INSCALAR_62_BITS-1:0] inscalar62,
    output [C_INSCALAR_63_BITS-1:0] inscalar63,
    output [C_INSCALAR_64_BITS-1:0] inscalar64,
    output [C_INSCALAR_65_BITS-1:0] inscalar65,
    output [C_INSCALAR_66_BITS-1:0] inscalar66,
    output [C_INSCALAR_67_BITS-1:0] inscalar67,
    output [C_INSCALAR_68_BITS-1:0] inscalar68,
    output [C_INSCALAR_69_BITS-1:0] inscalar69,
    output [C_INSCALAR_70_BITS-1:0] inscalar70,
    output [C_INSCALAR_71_BITS-1:0] inscalar71,
    output [C_INSCALAR_72_BITS-1:0] inscalar72,
    output [C_INSCALAR_73_BITS-1:0] inscalar73,
    output [C_INSCALAR_74_BITS-1:0] inscalar74,
    output [C_INSCALAR_75_BITS-1:0] inscalar75,
    output [C_INSCALAR_76_BITS-1:0] inscalar76,
    output [C_INSCALAR_77_BITS-1:0] inscalar77,
    output [C_INSCALAR_78_BITS-1:0] inscalar78,
    output [C_INSCALAR_79_BITS-1:0] inscalar79,
    output [C_INSCALAR_80_BITS-1:0] inscalar80,
    output [C_INSCALAR_81_BITS-1:0] inscalar81,
    output [C_INSCALAR_82_BITS-1:0] inscalar82,
    output [C_INSCALAR_83_BITS-1:0] inscalar83,
    output [C_INSCALAR_84_BITS-1:0] inscalar84,
    output [C_INSCALAR_85_BITS-1:0] inscalar85,
    output [C_INSCALAR_86_BITS-1:0] inscalar86,
    output [C_INSCALAR_87_BITS-1:0] inscalar87,
    output [C_INSCALAR_88_BITS-1:0] inscalar88,
    output [C_INSCALAR_89_BITS-1:0] inscalar89,
    output [C_INSCALAR_90_BITS-1:0] inscalar90,
    output [C_INSCALAR_91_BITS-1:0] inscalar91,
    output [C_INSCALAR_92_BITS-1:0] inscalar92,
    output [C_INSCALAR_93_BITS-1:0] inscalar93,
    output [C_INSCALAR_94_BITS-1:0] inscalar94,
    output [C_INSCALAR_95_BITS-1:0] inscalar95,
    output [C_INSCALAR_96_BITS-1:0] inscalar96,
    output [C_INSCALAR_97_BITS-1:0] inscalar97,
    output [C_INSCALAR_98_BITS-1:0] inscalar98,
    output [C_INSCALAR_99_BITS-1:0] inscalar99,
    output [C_INSCALAR_100_BITS-1:0] inscalar100,
    output [C_INSCALAR_101_BITS-1:0] inscalar101,
    output [C_INSCALAR_102_BITS-1:0] inscalar102,
    output [C_INSCALAR_103_BITS-1:0] inscalar103,
    output [C_INSCALAR_104_BITS-1:0] inscalar104,
    output [C_INSCALAR_105_BITS-1:0] inscalar105,
    output [C_INSCALAR_106_BITS-1:0] inscalar106,
    output [C_INSCALAR_107_BITS-1:0] inscalar107,
    output [C_INSCALAR_108_BITS-1:0] inscalar108,
    output [C_INSCALAR_109_BITS-1:0] inscalar109,
    output [C_INSCALAR_110_BITS-1:0] inscalar110,
    output [C_INSCALAR_111_BITS-1:0] inscalar111,
    output [C_INSCALAR_112_BITS-1:0] inscalar112,
    output [C_INSCALAR_113_BITS-1:0] inscalar113,
    output [C_INSCALAR_114_BITS-1:0] inscalar114,
    output [C_INSCALAR_115_BITS-1:0] inscalar115,
    output [C_INSCALAR_116_BITS-1:0] inscalar116,
    output [C_INSCALAR_117_BITS-1:0] inscalar117,
    output [C_INSCALAR_118_BITS-1:0] inscalar118,
    output [C_INSCALAR_119_BITS-1:0] inscalar119,
    output [C_INSCALAR_120_BITS-1:0] inscalar120,
    output [C_INSCALAR_121_BITS-1:0] inscalar121,
    output [C_INSCALAR_122_BITS-1:0] inscalar122,
    output [C_INSCALAR_123_BITS-1:0] inscalar123,
    output [C_INSCALAR_124_BITS-1:0] inscalar124,
    output [C_INSCALAR_125_BITS-1:0] inscalar125,
    output [C_INSCALAR_126_BITS-1:0] inscalar126,
    output [C_INSCALAR_127_BITS-1:0] inscalar127,
    //output scalar ports
    input [C_OUTSCALAR_0_BITS-1:0] outscalar0,
    input [C_OUTSCALAR_1_BITS-1:0] outscalar1,
    input [C_OUTSCALAR_2_BITS-1:0] outscalar2,
    input [C_OUTSCALAR_3_BITS-1:0] outscalar3,
    input [C_OUTSCALAR_4_BITS-1:0] outscalar4,
    input [C_OUTSCALAR_5_BITS-1:0] outscalar5,
    input [C_OUTSCALAR_6_BITS-1:0] outscalar6,
    input [C_OUTSCALAR_7_BITS-1:0] outscalar7,
    input [C_OUTSCALAR_8_BITS-1:0] outscalar8,
    input [C_OUTSCALAR_9_BITS-1:0] outscalar9,
    input [C_OUTSCALAR_10_BITS-1:0] outscalar10,
    input [C_OUTSCALAR_11_BITS-1:0] outscalar11,
    input [C_OUTSCALAR_12_BITS-1:0] outscalar12,
    input [C_OUTSCALAR_13_BITS-1:0] outscalar13,
    input [C_OUTSCALAR_14_BITS-1:0] outscalar14,
    input [C_OUTSCALAR_15_BITS-1:0] outscalar15,
    input [C_OUTSCALAR_16_BITS-1:0] outscalar16,
    input [C_OUTSCALAR_17_BITS-1:0] outscalar17,
    input [C_OUTSCALAR_18_BITS-1:0] outscalar18,
    input [C_OUTSCALAR_19_BITS-1:0] outscalar19,
    input [C_OUTSCALAR_20_BITS-1:0] outscalar20,
    input [C_OUTSCALAR_21_BITS-1:0] outscalar21,
    input [C_OUTSCALAR_22_BITS-1:0] outscalar22,
    input [C_OUTSCALAR_23_BITS-1:0] outscalar23,
    input [C_OUTSCALAR_24_BITS-1:0] outscalar24,
    input [C_OUTSCALAR_25_BITS-1:0] outscalar25,
    input [C_OUTSCALAR_26_BITS-1:0] outscalar26,
    input [C_OUTSCALAR_27_BITS-1:0] outscalar27,
    input [C_OUTSCALAR_28_BITS-1:0] outscalar28,
    input [C_OUTSCALAR_29_BITS-1:0] outscalar29,
    input [C_OUTSCALAR_30_BITS-1:0] outscalar30,
    input [C_OUTSCALAR_31_BITS-1:0] outscalar31,
    input [C_OUTSCALAR_32_BITS-1:0] outscalar32,
    input [C_OUTSCALAR_33_BITS-1:0] outscalar33,
    input [C_OUTSCALAR_34_BITS-1:0] outscalar34,
    input [C_OUTSCALAR_35_BITS-1:0] outscalar35,
    input [C_OUTSCALAR_36_BITS-1:0] outscalar36,
    input [C_OUTSCALAR_37_BITS-1:0] outscalar37,
    input [C_OUTSCALAR_38_BITS-1:0] outscalar38,
    input [C_OUTSCALAR_39_BITS-1:0] outscalar39,
    input [C_OUTSCALAR_40_BITS-1:0] outscalar40,
    input [C_OUTSCALAR_41_BITS-1:0] outscalar41,
    input [C_OUTSCALAR_42_BITS-1:0] outscalar42,
    input [C_OUTSCALAR_43_BITS-1:0] outscalar43,
    input [C_OUTSCALAR_44_BITS-1:0] outscalar44,
    input [C_OUTSCALAR_45_BITS-1:0] outscalar45,
    input [C_OUTSCALAR_46_BITS-1:0] outscalar46,
    input [C_OUTSCALAR_47_BITS-1:0] outscalar47,
    input [C_OUTSCALAR_48_BITS-1:0] outscalar48,
    input [C_OUTSCALAR_49_BITS-1:0] outscalar49,
    input [C_OUTSCALAR_50_BITS-1:0] outscalar50,
    input [C_OUTSCALAR_51_BITS-1:0] outscalar51,
    input [C_OUTSCALAR_52_BITS-1:0] outscalar52,
    input [C_OUTSCALAR_53_BITS-1:0] outscalar53,
    input [C_OUTSCALAR_54_BITS-1:0] outscalar54,
    input [C_OUTSCALAR_55_BITS-1:0] outscalar55,
    input [C_OUTSCALAR_56_BITS-1:0] outscalar56,
    input [C_OUTSCALAR_57_BITS-1:0] outscalar57,
    input [C_OUTSCALAR_58_BITS-1:0] outscalar58,
    input [C_OUTSCALAR_59_BITS-1:0] outscalar59,
    input [C_OUTSCALAR_60_BITS-1:0] outscalar60,
    input [C_OUTSCALAR_61_BITS-1:0] outscalar61,
    input [C_OUTSCALAR_62_BITS-1:0] outscalar62,
    input [C_OUTSCALAR_63_BITS-1:0] outscalar63,
    input [C_OUTSCALAR_64_BITS-1:0] outscalar64,
    input [C_OUTSCALAR_65_BITS-1:0] outscalar65,
    input [C_OUTSCALAR_66_BITS-1:0] outscalar66,
    input [C_OUTSCALAR_67_BITS-1:0] outscalar67,
    input [C_OUTSCALAR_68_BITS-1:0] outscalar68,
    input [C_OUTSCALAR_69_BITS-1:0] outscalar69,
    input [C_OUTSCALAR_70_BITS-1:0] outscalar70,
    input [C_OUTSCALAR_71_BITS-1:0] outscalar71,
    input [C_OUTSCALAR_72_BITS-1:0] outscalar72,
    input [C_OUTSCALAR_73_BITS-1:0] outscalar73,
    input [C_OUTSCALAR_74_BITS-1:0] outscalar74,
    input [C_OUTSCALAR_75_BITS-1:0] outscalar75,
    input [C_OUTSCALAR_76_BITS-1:0] outscalar76,
    input [C_OUTSCALAR_77_BITS-1:0] outscalar77,
    input [C_OUTSCALAR_78_BITS-1:0] outscalar78,
    input [C_OUTSCALAR_79_BITS-1:0] outscalar79,
    input [C_OUTSCALAR_80_BITS-1:0] outscalar80,
    input [C_OUTSCALAR_81_BITS-1:0] outscalar81,
    input [C_OUTSCALAR_82_BITS-1:0] outscalar82,
    input [C_OUTSCALAR_83_BITS-1:0] outscalar83,
    input [C_OUTSCALAR_84_BITS-1:0] outscalar84,
    input [C_OUTSCALAR_85_BITS-1:0] outscalar85,
    input [C_OUTSCALAR_86_BITS-1:0] outscalar86,
    input [C_OUTSCALAR_87_BITS-1:0] outscalar87,
    input [C_OUTSCALAR_88_BITS-1:0] outscalar88,
    input [C_OUTSCALAR_89_BITS-1:0] outscalar89,
    input [C_OUTSCALAR_90_BITS-1:0] outscalar90,
    input [C_OUTSCALAR_91_BITS-1:0] outscalar91,
    input [C_OUTSCALAR_92_BITS-1:0] outscalar92,
    input [C_OUTSCALAR_93_BITS-1:0] outscalar93,
    input [C_OUTSCALAR_94_BITS-1:0] outscalar94,
    input [C_OUTSCALAR_95_BITS-1:0] outscalar95,
    input [C_OUTSCALAR_96_BITS-1:0] outscalar96,
    input [C_OUTSCALAR_97_BITS-1:0] outscalar97,
    input [C_OUTSCALAR_98_BITS-1:0] outscalar98,
    input [C_OUTSCALAR_99_BITS-1:0] outscalar99,
    input [C_OUTSCALAR_100_BITS-1:0] outscalar100,
    input [C_OUTSCALAR_101_BITS-1:0] outscalar101,
    input [C_OUTSCALAR_102_BITS-1:0] outscalar102,
    input [C_OUTSCALAR_103_BITS-1:0] outscalar103,
    input [C_OUTSCALAR_104_BITS-1:0] outscalar104,
    input [C_OUTSCALAR_105_BITS-1:0] outscalar105,
    input [C_OUTSCALAR_106_BITS-1:0] outscalar106,
    input [C_OUTSCALAR_107_BITS-1:0] outscalar107,
    input [C_OUTSCALAR_108_BITS-1:0] outscalar108,
    input [C_OUTSCALAR_109_BITS-1:0] outscalar109,
    input [C_OUTSCALAR_110_BITS-1:0] outscalar110,
    input [C_OUTSCALAR_111_BITS-1:0] outscalar111,
    input [C_OUTSCALAR_112_BITS-1:0] outscalar112,
    input [C_OUTSCALAR_113_BITS-1:0] outscalar113,
    input [C_OUTSCALAR_114_BITS-1:0] outscalar114,
    input [C_OUTSCALAR_115_BITS-1:0] outscalar115,
    input [C_OUTSCALAR_116_BITS-1:0] outscalar116,
    input [C_OUTSCALAR_117_BITS-1:0] outscalar117,
    input [C_OUTSCALAR_118_BITS-1:0] outscalar118,
    input [C_OUTSCALAR_119_BITS-1:0] outscalar119,
    input [C_OUTSCALAR_120_BITS-1:0] outscalar120,
    input [C_OUTSCALAR_121_BITS-1:0] outscalar121,
    input [C_OUTSCALAR_122_BITS-1:0] outscalar122,
    input [C_OUTSCALAR_123_BITS-1:0] outscalar123,
    input [C_OUTSCALAR_124_BITS-1:0] outscalar124,
    input [C_OUTSCALAR_125_BITS-1:0] outscalar125,
    input [C_OUTSCALAR_126_BITS-1:0] outscalar126,
    input [C_OUTSCALAR_127_BITS-1:0] outscalar127,
    //output scalar valid ports
    input outscalar0_vld,
    input outscalar1_vld,
    input outscalar2_vld,
    input outscalar3_vld,
    input outscalar4_vld,
    input outscalar5_vld,
    input outscalar6_vld,
    input outscalar7_vld,
    input outscalar8_vld,
    input outscalar9_vld,
    input outscalar10_vld,
    input outscalar11_vld,
    input outscalar12_vld,
    input outscalar13_vld,
    input outscalar14_vld,
    input outscalar15_vld,
    input outscalar16_vld,
    input outscalar17_vld,
    input outscalar18_vld,
    input outscalar19_vld,
    input outscalar20_vld,
    input outscalar21_vld,
    input outscalar22_vld,
    input outscalar23_vld,
    input outscalar24_vld,
    input outscalar25_vld,
    input outscalar26_vld,
    input outscalar27_vld,
    input outscalar28_vld,
    input outscalar29_vld,
    input outscalar30_vld,
    input outscalar31_vld,
    input outscalar32_vld,
    input outscalar33_vld,
    input outscalar34_vld,
    input outscalar35_vld,
    input outscalar36_vld,
    input outscalar37_vld,
    input outscalar38_vld,
    input outscalar39_vld,
    input outscalar40_vld,
    input outscalar41_vld,
    input outscalar42_vld,
    input outscalar43_vld,
    input outscalar44_vld,
    input outscalar45_vld,
    input outscalar46_vld,
    input outscalar47_vld,
    input outscalar48_vld,
    input outscalar49_vld,
    input outscalar50_vld,
    input outscalar51_vld,
    input outscalar52_vld,
    input outscalar53_vld,
    input outscalar54_vld,
    input outscalar55_vld,
    input outscalar56_vld,
    input outscalar57_vld,
    input outscalar58_vld,
    input outscalar59_vld,
    input outscalar60_vld,
    input outscalar61_vld,
    input outscalar62_vld,
    input outscalar63_vld,
    input outscalar64_vld,
    input outscalar65_vld,
    input outscalar66_vld,
    input outscalar67_vld,
    input outscalar68_vld,
    input outscalar69_vld,
    input outscalar70_vld,
    input outscalar71_vld,
    input outscalar72_vld,
    input outscalar73_vld,
    input outscalar74_vld,
    input outscalar75_vld,
    input outscalar76_vld,
    input outscalar77_vld,
    input outscalar78_vld,
    input outscalar79_vld,
    input outscalar80_vld,
    input outscalar81_vld,
    input outscalar82_vld,
    input outscalar83_vld,
    input outscalar84_vld,
    input outscalar85_vld,
    input outscalar86_vld,
    input outscalar87_vld,
    input outscalar88_vld,
    input outscalar89_vld,
    input outscalar90_vld,
    input outscalar91_vld,
    input outscalar92_vld,
    input outscalar93_vld,
    input outscalar94_vld,
    input outscalar95_vld,
    input outscalar96_vld,
    input outscalar97_vld,
    input outscalar98_vld,
    input outscalar99_vld,
    input outscalar100_vld,
    input outscalar101_vld,
    input outscalar102_vld,
    input outscalar103_vld,
    input outscalar104_vld,
    input outscalar105_vld,
    input outscalar106_vld,
    input outscalar107_vld,
    input outscalar108_vld,
    input outscalar109_vld,
    input outscalar110_vld,
    input outscalar111_vld,
    input outscalar112_vld,
    input outscalar113_vld,
    input outscalar114_vld,
    input outscalar115_vld,
    input outscalar116_vld,
    input outscalar117_vld,
    input outscalar118_vld,
    input outscalar119_vld,
    input outscalar120_vld,
    input outscalar121_vld,
    input outscalar122_vld,
    input outscalar123_vld,
    input outscalar124_vld,
    input outscalar125_vld,
    input outscalar126_vld,
    input outscalar127_vld
);

parameter C_NUM_INSCALARS = 0;
parameter C_NUM_OUTSCALARS = 0;
parameter C_FIFO_DEPTH = 16;
parameter C_HAS_RETURN = 0;

parameter [31:0] C_INSCALAR_0_BITS = 32;
parameter [31:0] C_INSCALAR_1_BITS = 32;
parameter [31:0] C_INSCALAR_2_BITS = 32;
parameter [31:0] C_INSCALAR_3_BITS = 32;
parameter [31:0] C_INSCALAR_4_BITS = 32;
parameter [31:0] C_INSCALAR_5_BITS = 32;
parameter [31:0] C_INSCALAR_6_BITS = 32;
parameter [31:0] C_INSCALAR_7_BITS = 32;
parameter [31:0] C_INSCALAR_8_BITS = 32;
parameter [31:0] C_INSCALAR_9_BITS = 32;
parameter [31:0] C_INSCALAR_10_BITS = 32;
parameter [31:0] C_INSCALAR_11_BITS = 32;
parameter [31:0] C_INSCALAR_12_BITS = 32;
parameter [31:0] C_INSCALAR_13_BITS = 32;
parameter [31:0] C_INSCALAR_14_BITS = 32;
parameter [31:0] C_INSCALAR_15_BITS = 32;
parameter [31:0] C_INSCALAR_16_BITS = 32;
parameter [31:0] C_INSCALAR_17_BITS = 32;
parameter [31:0] C_INSCALAR_18_BITS = 32;
parameter [31:0] C_INSCALAR_19_BITS = 32;
parameter [31:0] C_INSCALAR_20_BITS = 32;
parameter [31:0] C_INSCALAR_21_BITS = 32;
parameter [31:0] C_INSCALAR_22_BITS = 32;
parameter [31:0] C_INSCALAR_23_BITS = 32;
parameter [31:0] C_INSCALAR_24_BITS = 32;
parameter [31:0] C_INSCALAR_25_BITS = 32;
parameter [31:0] C_INSCALAR_26_BITS = 32;
parameter [31:0] C_INSCALAR_27_BITS = 32;
parameter [31:0] C_INSCALAR_28_BITS = 32;
parameter [31:0] C_INSCALAR_29_BITS = 32;
parameter [31:0] C_INSCALAR_30_BITS = 32;
parameter [31:0] C_INSCALAR_31_BITS = 32;
parameter [31:0] C_INSCALAR_32_BITS = 32;
parameter [31:0] C_INSCALAR_33_BITS = 32;
parameter [31:0] C_INSCALAR_34_BITS = 32;
parameter [31:0] C_INSCALAR_35_BITS = 32;
parameter [31:0] C_INSCALAR_36_BITS = 32;
parameter [31:0] C_INSCALAR_37_BITS = 32;
parameter [31:0] C_INSCALAR_38_BITS = 32;
parameter [31:0] C_INSCALAR_39_BITS = 32;
parameter [31:0] C_INSCALAR_40_BITS = 32;
parameter [31:0] C_INSCALAR_41_BITS = 32;
parameter [31:0] C_INSCALAR_42_BITS = 32;
parameter [31:0] C_INSCALAR_43_BITS = 32;
parameter [31:0] C_INSCALAR_44_BITS = 32;
parameter [31:0] C_INSCALAR_45_BITS = 32;
parameter [31:0] C_INSCALAR_46_BITS = 32;
parameter [31:0] C_INSCALAR_47_BITS = 32;
parameter [31:0] C_INSCALAR_48_BITS = 32;
parameter [31:0] C_INSCALAR_49_BITS = 32;
parameter [31:0] C_INSCALAR_50_BITS = 32;
parameter [31:0] C_INSCALAR_51_BITS = 32;
parameter [31:0] C_INSCALAR_52_BITS = 32;
parameter [31:0] C_INSCALAR_53_BITS = 32;
parameter [31:0] C_INSCALAR_54_BITS = 32;
parameter [31:0] C_INSCALAR_55_BITS = 32;
parameter [31:0] C_INSCALAR_56_BITS = 32;
parameter [31:0] C_INSCALAR_57_BITS = 32;
parameter [31:0] C_INSCALAR_58_BITS = 32;
parameter [31:0] C_INSCALAR_59_BITS = 32;
parameter [31:0] C_INSCALAR_60_BITS = 32;
parameter [31:0] C_INSCALAR_61_BITS = 32;
parameter [31:0] C_INSCALAR_62_BITS = 32;
parameter [31:0] C_INSCALAR_63_BITS = 32;
parameter [31:0] C_INSCALAR_64_BITS = 32;
parameter [31:0] C_INSCALAR_65_BITS = 32;
parameter [31:0] C_INSCALAR_66_BITS = 32;
parameter [31:0] C_INSCALAR_67_BITS = 32;
parameter [31:0] C_INSCALAR_68_BITS = 32;
parameter [31:0] C_INSCALAR_69_BITS = 32;
parameter [31:0] C_INSCALAR_70_BITS = 32;
parameter [31:0] C_INSCALAR_71_BITS = 32;
parameter [31:0] C_INSCALAR_72_BITS = 32;
parameter [31:0] C_INSCALAR_73_BITS = 32;
parameter [31:0] C_INSCALAR_74_BITS = 32;
parameter [31:0] C_INSCALAR_75_BITS = 32;
parameter [31:0] C_INSCALAR_76_BITS = 32;
parameter [31:0] C_INSCALAR_77_BITS = 32;
parameter [31:0] C_INSCALAR_78_BITS = 32;
parameter [31:0] C_INSCALAR_79_BITS = 32;
parameter [31:0] C_INSCALAR_80_BITS = 32;
parameter [31:0] C_INSCALAR_81_BITS = 32;
parameter [31:0] C_INSCALAR_82_BITS = 32;
parameter [31:0] C_INSCALAR_83_BITS = 32;
parameter [31:0] C_INSCALAR_84_BITS = 32;
parameter [31:0] C_INSCALAR_85_BITS = 32;
parameter [31:0] C_INSCALAR_86_BITS = 32;
parameter [31:0] C_INSCALAR_87_BITS = 32;
parameter [31:0] C_INSCALAR_88_BITS = 32;
parameter [31:0] C_INSCALAR_89_BITS = 32;
parameter [31:0] C_INSCALAR_90_BITS = 32;
parameter [31:0] C_INSCALAR_91_BITS = 32;
parameter [31:0] C_INSCALAR_92_BITS = 32;
parameter [31:0] C_INSCALAR_93_BITS = 32;
parameter [31:0] C_INSCALAR_94_BITS = 32;
parameter [31:0] C_INSCALAR_95_BITS = 32;
parameter [31:0] C_INSCALAR_96_BITS = 32;
parameter [31:0] C_INSCALAR_97_BITS = 32;
parameter [31:0] C_INSCALAR_98_BITS = 32;
parameter [31:0] C_INSCALAR_99_BITS = 32;
parameter [31:0] C_INSCALAR_100_BITS = 32;
parameter [31:0] C_INSCALAR_101_BITS = 32;
parameter [31:0] C_INSCALAR_102_BITS = 32;
parameter [31:0] C_INSCALAR_103_BITS = 32;
parameter [31:0] C_INSCALAR_104_BITS = 32;
parameter [31:0] C_INSCALAR_105_BITS = 32;
parameter [31:0] C_INSCALAR_106_BITS = 32;
parameter [31:0] C_INSCALAR_107_BITS = 32;
parameter [31:0] C_INSCALAR_108_BITS = 32;
parameter [31:0] C_INSCALAR_109_BITS = 32;
parameter [31:0] C_INSCALAR_110_BITS = 32;
parameter [31:0] C_INSCALAR_111_BITS = 32;
parameter [31:0] C_INSCALAR_112_BITS = 32;
parameter [31:0] C_INSCALAR_113_BITS = 32;
parameter [31:0] C_INSCALAR_114_BITS = 32;
parameter [31:0] C_INSCALAR_115_BITS = 32;
parameter [31:0] C_INSCALAR_116_BITS = 32;
parameter [31:0] C_INSCALAR_117_BITS = 32;
parameter [31:0] C_INSCALAR_118_BITS = 32;
parameter [31:0] C_INSCALAR_119_BITS = 32;
parameter [31:0] C_INSCALAR_120_BITS = 32;
parameter [31:0] C_INSCALAR_121_BITS = 32;
parameter [31:0] C_INSCALAR_122_BITS = 32;
parameter [31:0] C_INSCALAR_123_BITS = 32;
parameter [31:0] C_INSCALAR_124_BITS = 32;
parameter [31:0] C_INSCALAR_125_BITS = 32;
parameter [31:0] C_INSCALAR_126_BITS = 32;
parameter [31:0] C_INSCALAR_127_BITS = 32;

parameter [31:0]  C_OUTSCALAR_0_BITS = 32;
parameter [31:0]  C_OUTSCALAR_1_BITS = 32;
parameter [31:0]  C_OUTSCALAR_2_BITS = 32;
parameter [31:0]  C_OUTSCALAR_3_BITS = 32;
parameter [31:0]  C_OUTSCALAR_4_BITS = 32;
parameter [31:0]  C_OUTSCALAR_5_BITS = 32;
parameter [31:0]  C_OUTSCALAR_6_BITS = 32;
parameter [31:0]  C_OUTSCALAR_7_BITS = 32;
parameter [31:0]  C_OUTSCALAR_8_BITS = 32;
parameter [31:0]  C_OUTSCALAR_9_BITS = 32;
parameter [31:0]  C_OUTSCALAR_10_BITS = 32;
parameter [31:0]  C_OUTSCALAR_11_BITS = 32;
parameter [31:0]  C_OUTSCALAR_12_BITS = 32;
parameter [31:0]  C_OUTSCALAR_13_BITS = 32;
parameter [31:0]  C_OUTSCALAR_14_BITS = 32;
parameter [31:0]  C_OUTSCALAR_15_BITS = 32;
parameter [31:0]  C_OUTSCALAR_16_BITS = 32;
parameter [31:0]  C_OUTSCALAR_17_BITS = 32;
parameter [31:0]  C_OUTSCALAR_18_BITS = 32;
parameter [31:0]  C_OUTSCALAR_19_BITS = 32;
parameter [31:0]  C_OUTSCALAR_20_BITS = 32;
parameter [31:0]  C_OUTSCALAR_21_BITS = 32;
parameter [31:0]  C_OUTSCALAR_22_BITS = 32;
parameter [31:0]  C_OUTSCALAR_23_BITS = 32;
parameter [31:0]  C_OUTSCALAR_24_BITS = 32;
parameter [31:0]  C_OUTSCALAR_25_BITS = 32;
parameter [31:0]  C_OUTSCALAR_26_BITS = 32;
parameter [31:0]  C_OUTSCALAR_27_BITS = 32;
parameter [31:0]  C_OUTSCALAR_28_BITS = 32;
parameter [31:0]  C_OUTSCALAR_29_BITS = 32;
parameter [31:0]  C_OUTSCALAR_30_BITS = 32;
parameter [31:0]  C_OUTSCALAR_31_BITS = 32;
parameter [31:0]  C_OUTSCALAR_32_BITS = 32;
parameter [31:0]  C_OUTSCALAR_33_BITS = 32;
parameter [31:0]  C_OUTSCALAR_34_BITS = 32;
parameter [31:0]  C_OUTSCALAR_35_BITS = 32;
parameter [31:0]  C_OUTSCALAR_36_BITS = 32;
parameter [31:0]  C_OUTSCALAR_37_BITS = 32;
parameter [31:0]  C_OUTSCALAR_38_BITS = 32;
parameter [31:0]  C_OUTSCALAR_39_BITS = 32;
parameter [31:0]  C_OUTSCALAR_40_BITS = 32;
parameter [31:0]  C_OUTSCALAR_41_BITS = 32;
parameter [31:0]  C_OUTSCALAR_42_BITS = 32;
parameter [31:0]  C_OUTSCALAR_43_BITS = 32;
parameter [31:0]  C_OUTSCALAR_44_BITS = 32;
parameter [31:0]  C_OUTSCALAR_45_BITS = 32;
parameter [31:0]  C_OUTSCALAR_46_BITS = 32;
parameter [31:0]  C_OUTSCALAR_47_BITS = 32;
parameter [31:0]  C_OUTSCALAR_48_BITS = 32;
parameter [31:0]  C_OUTSCALAR_49_BITS = 32;
parameter [31:0]  C_OUTSCALAR_50_BITS = 32;
parameter [31:0]  C_OUTSCALAR_51_BITS = 32;
parameter [31:0]  C_OUTSCALAR_52_BITS = 32;
parameter [31:0]  C_OUTSCALAR_53_BITS = 32;
parameter [31:0]  C_OUTSCALAR_54_BITS = 32;
parameter [31:0]  C_OUTSCALAR_55_BITS = 32;
parameter [31:0]  C_OUTSCALAR_56_BITS = 32;
parameter [31:0]  C_OUTSCALAR_57_BITS = 32;
parameter [31:0]  C_OUTSCALAR_58_BITS = 32;
parameter [31:0]  C_OUTSCALAR_59_BITS = 32;
parameter [31:0]  C_OUTSCALAR_60_BITS = 32;
parameter [31:0]  C_OUTSCALAR_61_BITS = 32;
parameter [31:0]  C_OUTSCALAR_62_BITS = 32;
parameter [31:0]  C_OUTSCALAR_63_BITS = 32;
parameter [31:0]  C_OUTSCALAR_64_BITS = 32;
parameter [31:0]  C_OUTSCALAR_65_BITS = 32;
parameter [31:0]  C_OUTSCALAR_66_BITS = 32;
parameter [31:0]  C_OUTSCALAR_67_BITS = 32;
parameter [31:0]  C_OUTSCALAR_68_BITS = 32;
parameter [31:0]  C_OUTSCALAR_69_BITS = 32;
parameter [31:0]  C_OUTSCALAR_70_BITS = 32;
parameter [31:0]  C_OUTSCALAR_71_BITS = 32;
parameter [31:0]  C_OUTSCALAR_72_BITS = 32;
parameter [31:0]  C_OUTSCALAR_73_BITS = 32;
parameter [31:0]  C_OUTSCALAR_74_BITS = 32;
parameter [31:0]  C_OUTSCALAR_75_BITS = 32;
parameter [31:0]  C_OUTSCALAR_76_BITS = 32;
parameter [31:0]  C_OUTSCALAR_77_BITS = 32;
parameter [31:0]  C_OUTSCALAR_78_BITS = 32;
parameter [31:0]  C_OUTSCALAR_79_BITS = 32;
parameter [31:0]  C_OUTSCALAR_80_BITS = 32;
parameter [31:0]  C_OUTSCALAR_81_BITS = 32;
parameter [31:0]  C_OUTSCALAR_82_BITS = 32;
parameter [31:0]  C_OUTSCALAR_83_BITS = 32;
parameter [31:0]  C_OUTSCALAR_84_BITS = 32;
parameter [31:0]  C_OUTSCALAR_85_BITS = 32;
parameter [31:0]  C_OUTSCALAR_86_BITS = 32;
parameter [31:0]  C_OUTSCALAR_87_BITS = 32;
parameter [31:0]  C_OUTSCALAR_88_BITS = 32;
parameter [31:0]  C_OUTSCALAR_89_BITS = 32;
parameter [31:0]  C_OUTSCALAR_90_BITS = 32;
parameter [31:0]  C_OUTSCALAR_91_BITS = 32;
parameter [31:0]  C_OUTSCALAR_92_BITS = 32;
parameter [31:0]  C_OUTSCALAR_93_BITS = 32;
parameter [31:0]  C_OUTSCALAR_94_BITS = 32;
parameter [31:0]  C_OUTSCALAR_95_BITS = 32;
parameter [31:0]  C_OUTSCALAR_96_BITS = 32;
parameter [31:0]  C_OUTSCALAR_97_BITS = 32;
parameter [31:0]  C_OUTSCALAR_98_BITS = 32;
parameter [31:0]  C_OUTSCALAR_99_BITS = 32;
parameter [31:0]  C_OUTSCALAR_100_BITS = 32;
parameter [31:0]  C_OUTSCALAR_101_BITS = 32;
parameter [31:0]  C_OUTSCALAR_102_BITS = 32;
parameter [31:0]  C_OUTSCALAR_103_BITS = 32;
parameter [31:0]  C_OUTSCALAR_104_BITS = 32;
parameter [31:0]  C_OUTSCALAR_105_BITS = 32;
parameter [31:0]  C_OUTSCALAR_106_BITS = 32;
parameter [31:0]  C_OUTSCALAR_107_BITS = 32;
parameter [31:0]  C_OUTSCALAR_108_BITS = 32;
parameter [31:0]  C_OUTSCALAR_109_BITS = 32;
parameter [31:0]  C_OUTSCALAR_110_BITS = 32;
parameter [31:0]  C_OUTSCALAR_111_BITS = 32;
parameter [31:0]  C_OUTSCALAR_112_BITS = 32;
parameter [31:0]  C_OUTSCALAR_113_BITS = 32;
parameter [31:0]  C_OUTSCALAR_114_BITS = 32;
parameter [31:0]  C_OUTSCALAR_115_BITS = 32;
parameter [31:0]  C_OUTSCALAR_116_BITS = 32;
parameter [31:0]  C_OUTSCALAR_117_BITS = 32;
parameter [31:0]  C_OUTSCALAR_118_BITS = 32;
parameter [31:0]  C_OUTSCALAR_119_BITS = 32;
parameter [31:0]  C_OUTSCALAR_120_BITS = 32;
parameter [31:0]  C_OUTSCALAR_121_BITS = 32;
parameter [31:0]  C_OUTSCALAR_122_BITS = 32;
parameter [31:0]  C_OUTSCALAR_123_BITS = 32;
parameter [31:0]  C_OUTSCALAR_124_BITS = 32;
parameter [31:0]  C_OUTSCALAR_125_BITS = 32;
parameter [31:0]  C_OUTSCALAR_126_BITS = 32;
parameter [31:0]  C_OUTSCALAR_127_BITS = 32;

localparam C_MAX_INSCALARS = 128;
localparam [(C_MAX_INSCALARS*32)-1:0] C_INSCALAR_BIT_ARRAY = {C_INSCALAR_127_BITS,C_INSCALAR_126_BITS,C_INSCALAR_125_BITS,C_INSCALAR_124_BITS,C_INSCALAR_123_BITS,C_INSCALAR_122_BITS,C_INSCALAR_121_BITS,C_INSCALAR_120_BITS,C_INSCALAR_119_BITS,C_INSCALAR_118_BITS,C_INSCALAR_117_BITS,C_INSCALAR_116_BITS,C_INSCALAR_115_BITS,C_INSCALAR_114_BITS,C_INSCALAR_113_BITS,C_INSCALAR_112_BITS,C_INSCALAR_111_BITS,C_INSCALAR_110_BITS,C_INSCALAR_109_BITS,C_INSCALAR_108_BITS,C_INSCALAR_107_BITS,C_INSCALAR_106_BITS,C_INSCALAR_105_BITS,C_INSCALAR_104_BITS,C_INSCALAR_103_BITS,C_INSCALAR_102_BITS,C_INSCALAR_101_BITS,C_INSCALAR_100_BITS,C_INSCALAR_99_BITS,C_INSCALAR_98_BITS,C_INSCALAR_97_BITS,C_INSCALAR_96_BITS,C_INSCALAR_95_BITS,C_INSCALAR_94_BITS,C_INSCALAR_93_BITS,C_INSCALAR_92_BITS,C_INSCALAR_91_BITS,C_INSCALAR_90_BITS,C_INSCALAR_89_BITS,C_INSCALAR_88_BITS,C_INSCALAR_87_BITS,C_INSCALAR_86_BITS,C_INSCALAR_85_BITS,C_INSCALAR_84_BITS,C_INSCALAR_83_BITS,C_INSCALAR_82_BITS,C_INSCALAR_81_BITS,C_INSCALAR_80_BITS,C_INSCALAR_79_BITS,C_INSCALAR_78_BITS,C_INSCALAR_77_BITS,C_INSCALAR_76_BITS,C_INSCALAR_75_BITS,C_INSCALAR_74_BITS,C_INSCALAR_73_BITS,C_INSCALAR_72_BITS,C_INSCALAR_71_BITS,C_INSCALAR_70_BITS,C_INSCALAR_69_BITS,C_INSCALAR_68_BITS,C_INSCALAR_67_BITS,C_INSCALAR_66_BITS,C_INSCALAR_65_BITS,C_INSCALAR_64_BITS,C_INSCALAR_63_BITS,C_INSCALAR_62_BITS,C_INSCALAR_61_BITS,C_INSCALAR_60_BITS,C_INSCALAR_59_BITS,C_INSCALAR_58_BITS,C_INSCALAR_57_BITS,C_INSCALAR_56_BITS,C_INSCALAR_55_BITS,C_INSCALAR_54_BITS,C_INSCALAR_53_BITS,C_INSCALAR_52_BITS,C_INSCALAR_51_BITS,C_INSCALAR_50_BITS,C_INSCALAR_49_BITS,C_INSCALAR_48_BITS,C_INSCALAR_47_BITS,C_INSCALAR_46_BITS,C_INSCALAR_45_BITS,C_INSCALAR_44_BITS,C_INSCALAR_43_BITS,C_INSCALAR_42_BITS,C_INSCALAR_41_BITS,C_INSCALAR_40_BITS,C_INSCALAR_39_BITS,C_INSCALAR_38_BITS,C_INSCALAR_37_BITS,C_INSCALAR_36_BITS,C_INSCALAR_35_BITS,C_INSCALAR_34_BITS,C_INSCALAR_33_BITS,C_INSCALAR_32_BITS,C_INSCALAR_31_BITS,C_INSCALAR_30_BITS,C_INSCALAR_29_BITS,C_INSCALAR_28_BITS,C_INSCALAR_27_BITS,C_INSCALAR_26_BITS,C_INSCALAR_25_BITS,C_INSCALAR_24_BITS,C_INSCALAR_23_BITS,C_INSCALAR_22_BITS,C_INSCALAR_21_BITS,C_INSCALAR_20_BITS,C_INSCALAR_19_BITS,C_INSCALAR_18_BITS,C_INSCALAR_17_BITS,C_INSCALAR_16_BITS,C_INSCALAR_15_BITS,C_INSCALAR_14_BITS,C_INSCALAR_13_BITS,C_INSCALAR_12_BITS,C_INSCALAR_11_BITS,C_INSCALAR_10_BITS,C_INSCALAR_9_BITS,C_INSCALAR_8_BITS,C_INSCALAR_7_BITS,C_INSCALAR_6_BITS,C_INSCALAR_5_BITS,C_INSCALAR_4_BITS,C_INSCALAR_3_BITS,C_INSCALAR_2_BITS,C_INSCALAR_1_BITS,C_INSCALAR_0_BITS};

localparam C_MAX_OUTSCALARS = 128;
localparam [(C_MAX_OUTSCALARS*32)-1:0] C_OUTSCALAR_BIT_ARRAY = {C_OUTSCALAR_127_BITS,C_OUTSCALAR_126_BITS,C_OUTSCALAR_125_BITS,C_OUTSCALAR_124_BITS,C_OUTSCALAR_123_BITS,C_OUTSCALAR_122_BITS,C_OUTSCALAR_121_BITS,C_OUTSCALAR_120_BITS,C_OUTSCALAR_119_BITS,C_OUTSCALAR_118_BITS,C_OUTSCALAR_117_BITS,C_OUTSCALAR_116_BITS,C_OUTSCALAR_115_BITS,C_OUTSCALAR_114_BITS,C_OUTSCALAR_113_BITS,C_OUTSCALAR_112_BITS,C_OUTSCALAR_111_BITS,C_OUTSCALAR_110_BITS,C_OUTSCALAR_109_BITS,C_OUTSCALAR_108_BITS,C_OUTSCALAR_107_BITS,C_OUTSCALAR_106_BITS,C_OUTSCALAR_105_BITS,C_OUTSCALAR_104_BITS,C_OUTSCALAR_103_BITS,C_OUTSCALAR_102_BITS,C_OUTSCALAR_101_BITS,C_OUTSCALAR_100_BITS,C_OUTSCALAR_99_BITS,C_OUTSCALAR_98_BITS,C_OUTSCALAR_97_BITS,C_OUTSCALAR_96_BITS,C_OUTSCALAR_95_BITS,C_OUTSCALAR_94_BITS,C_OUTSCALAR_93_BITS,C_OUTSCALAR_92_BITS,C_OUTSCALAR_91_BITS,C_OUTSCALAR_90_BITS,C_OUTSCALAR_89_BITS,C_OUTSCALAR_88_BITS,C_OUTSCALAR_87_BITS,C_OUTSCALAR_86_BITS,C_OUTSCALAR_85_BITS,C_OUTSCALAR_84_BITS,C_OUTSCALAR_83_BITS,C_OUTSCALAR_82_BITS,C_OUTSCALAR_81_BITS,C_OUTSCALAR_80_BITS,C_OUTSCALAR_79_BITS,C_OUTSCALAR_78_BITS,C_OUTSCALAR_77_BITS,C_OUTSCALAR_76_BITS,C_OUTSCALAR_75_BITS,C_OUTSCALAR_74_BITS,C_OUTSCALAR_73_BITS,C_OUTSCALAR_72_BITS,C_OUTSCALAR_71_BITS,C_OUTSCALAR_70_BITS,C_OUTSCALAR_69_BITS,C_OUTSCALAR_68_BITS,C_OUTSCALAR_67_BITS,C_OUTSCALAR_66_BITS,C_OUTSCALAR_65_BITS,C_OUTSCALAR_64_BITS,C_OUTSCALAR_63_BITS,C_OUTSCALAR_62_BITS,C_OUTSCALAR_61_BITS,C_OUTSCALAR_60_BITS,C_OUTSCALAR_59_BITS,C_OUTSCALAR_58_BITS,C_OUTSCALAR_57_BITS,C_OUTSCALAR_56_BITS,C_OUTSCALAR_55_BITS,C_OUTSCALAR_54_BITS,C_OUTSCALAR_53_BITS,C_OUTSCALAR_52_BITS,C_OUTSCALAR_51_BITS,C_OUTSCALAR_50_BITS,C_OUTSCALAR_49_BITS,C_OUTSCALAR_48_BITS,C_OUTSCALAR_47_BITS,C_OUTSCALAR_46_BITS,C_OUTSCALAR_45_BITS,C_OUTSCALAR_44_BITS,C_OUTSCALAR_43_BITS,C_OUTSCALAR_42_BITS,C_OUTSCALAR_41_BITS,C_OUTSCALAR_40_BITS,C_OUTSCALAR_39_BITS,C_OUTSCALAR_38_BITS,C_OUTSCALAR_37_BITS,C_OUTSCALAR_36_BITS,C_OUTSCALAR_35_BITS,C_OUTSCALAR_34_BITS,C_OUTSCALAR_33_BITS,C_OUTSCALAR_32_BITS,C_OUTSCALAR_31_BITS,C_OUTSCALAR_30_BITS,C_OUTSCALAR_29_BITS,C_OUTSCALAR_28_BITS,C_OUTSCALAR_27_BITS,C_OUTSCALAR_26_BITS,C_OUTSCALAR_25_BITS,C_OUTSCALAR_24_BITS,C_OUTSCALAR_23_BITS,C_OUTSCALAR_22_BITS,C_OUTSCALAR_21_BITS,C_OUTSCALAR_20_BITS,C_OUTSCALAR_19_BITS,C_OUTSCALAR_18_BITS,C_OUTSCALAR_17_BITS,C_OUTSCALAR_16_BITS,C_OUTSCALAR_15_BITS,C_OUTSCALAR_14_BITS,C_OUTSCALAR_13_BITS,C_OUTSCALAR_12_BITS,C_OUTSCALAR_11_BITS,C_OUTSCALAR_10_BITS,C_OUTSCALAR_9_BITS,C_OUTSCALAR_8_BITS,C_OUTSCALAR_7_BITS,C_OUTSCALAR_6_BITS,C_OUTSCALAR_5_BITS,C_OUTSCALAR_4_BITS,C_OUTSCALAR_3_BITS,C_OUTSCALAR_2_BITS,C_OUTSCALAR_1_BITS,C_OUTSCALAR_0_BITS};

localparam C_MAX_SCALAR_BITS = 1024;

reg [31:0] scalar_out_reg;  //output data register for control interface

wire [C_NUM_INSCALARS-1:0] inscalar_we;                              //write enables for input scalars
wire [C_MAX_SCALAR_BITS-1:0] inscalar_fifo [0:C_NUM_INSCALARS-1];    //input scalar data values from register to fifo
wire [C_MAX_SCALAR_BITS-1:0] inscalar [0:C_NUM_INSCALARS-1];         //input scalar data values from fifo to ports
wire [C_MAX_INSCALARS-1:0] inscalar_ready;                           //input scalar ready to be buffered in fifo

wire [C_NUM_OUTSCALARS-1:0] outscalar_re;                            //read enables for output scalars
wire [C_MAX_SCALAR_BITS-1:0] outscalar [0:C_NUM_OUTSCALARS-1];       //output scalar data values from port into reg
reg  [C_MAX_SCALAR_BITS-1:0] outscalar_reg [0:C_NUM_OUTSCALARS-1];   //output scalar data values from reg into fifo
wire [C_MAX_SCALAR_BITS-1:0] outscalar_fifo [0:C_NUM_OUTSCALARS-1];  //output scalar data values from fifo into 32bit interface
wire [31:0] outscalar_fifo32 [0:C_NUM_OUTSCALARS-1];                 //output scalar data values from fifo 32bit chunk (for reading)
wire [C_NUM_OUTSCALARS-1:0] outscalar_vld;                           //output scalar valid signals
reg [C_NUM_OUTSCALARS-1:0] outscalar_found_vld;                     //output scalar valid found signals
wire [C_NUM_OUTSCALARS-1:0] outscalar_read;                         //read signal from the out_register to the outscalar_fifo

reg capture_reg;//register the capture signal to trigger the next cycle

always @(posedge acc_clk)
    capture_reg <= outscalar_capture;

generate
    //map input scalar data values from register to ports
    if(C_NUM_INSCALARS > 0)
        assign inscalar0 = inscalar[0][C_INSCALAR_0_BITS-1:0];
    else begin
        assign inscalar0 = 0;
        assign inscalar_fifo_empty = 0;
        assign inscalar_fifo_full = 0;
    end

    if(C_NUM_INSCALARS > 1)
        assign inscalar1 = inscalar[1][C_INSCALAR_1_BITS-1:0];
    else
        assign inscalar1 = 0;

    if(C_NUM_INSCALARS > 2)
        assign inscalar2 = inscalar[2][C_INSCALAR_2_BITS-1:0];
    else
        assign inscalar2 = 0;

    if(C_NUM_INSCALARS > 3)
        assign inscalar3 = inscalar[3][C_INSCALAR_3_BITS-1:0];
    else
        assign inscalar3 = 0;

    if(C_NUM_INSCALARS > 4)
        assign inscalar4 = inscalar[4][C_INSCALAR_4_BITS-1:0];
    else
        assign inscalar4 = 0;

    if(C_NUM_INSCALARS > 5)
        assign inscalar5 = inscalar[5][C_INSCALAR_5_BITS-1:0];
    else
        assign inscalar5 = 0;

    if(C_NUM_INSCALARS > 6)
        assign inscalar6 = inscalar[6][C_INSCALAR_6_BITS-1:0];
    else
        assign inscalar6 = 0;

    if(C_NUM_INSCALARS > 7)
        assign inscalar7 = inscalar[7][C_INSCALAR_7_BITS-1:0];
    else
        assign inscalar7 = 0;

    if(C_NUM_INSCALARS > 8)
        assign inscalar8 = inscalar[8][C_INSCALAR_8_BITS-1:0];
    else
        assign inscalar8 = 0;

    if(C_NUM_INSCALARS > 9)
        assign inscalar9 = inscalar[9][C_INSCALAR_9_BITS-1:0];
    else
        assign inscalar9 = 0;

    if(C_NUM_INSCALARS > 10)
        assign inscalar10 = inscalar[10][C_INSCALAR_10_BITS-1:0];
    else
        assign inscalar10 = 0;

    if(C_NUM_INSCALARS > 11)
        assign inscalar11 = inscalar[11][C_INSCALAR_11_BITS-1:0];
    else
        assign inscalar11 = 0;

    if(C_NUM_INSCALARS > 12)
        assign inscalar12 = inscalar[12][C_INSCALAR_12_BITS-1:0];
    else
        assign inscalar12 = 0;

    if(C_NUM_INSCALARS > 13)
        assign inscalar13 = inscalar[13][C_INSCALAR_13_BITS-1:0];
    else
        assign inscalar13 = 0;

    if(C_NUM_INSCALARS > 14)
        assign inscalar14 = inscalar[14][C_INSCALAR_14_BITS-1:0];
    else
        assign inscalar14 = 0;

    if(C_NUM_INSCALARS > 15)
        assign inscalar15 = inscalar[15][C_INSCALAR_15_BITS-1:0];
    else
        assign inscalar15 = 0;

    if(C_NUM_INSCALARS > 16)
        assign inscalar16 = inscalar[16][C_INSCALAR_16_BITS-1:0];
    else
        assign inscalar16 = 0;

    if(C_NUM_INSCALARS > 17)
        assign inscalar17 = inscalar[17][C_INSCALAR_17_BITS-1:0];
    else
        assign inscalar17 = 0;

    if(C_NUM_INSCALARS > 18)
        assign inscalar18 = inscalar[18][C_INSCALAR_18_BITS-1:0];
    else
        assign inscalar18 = 0;

    if(C_NUM_INSCALARS > 19)
        assign inscalar19 = inscalar[19][C_INSCALAR_19_BITS-1:0];
    else
        assign inscalar19 = 0;

    if(C_NUM_INSCALARS > 20)
        assign inscalar20 = inscalar[20][C_INSCALAR_20_BITS-1:0];
    else
        assign inscalar20 = 0;

    if(C_NUM_INSCALARS > 21)
        assign inscalar21 = inscalar[21][C_INSCALAR_21_BITS-1:0];
    else
        assign inscalar21 = 0;

    if(C_NUM_INSCALARS > 22)
        assign inscalar22 = inscalar[22][C_INSCALAR_22_BITS-1:0];
    else
        assign inscalar22 = 0;

    if(C_NUM_INSCALARS > 23)
        assign inscalar23 = inscalar[23][C_INSCALAR_23_BITS-1:0];
    else
        assign inscalar23 = 0;

    if(C_NUM_INSCALARS > 24)
        assign inscalar24 = inscalar[24][C_INSCALAR_24_BITS-1:0];
    else
        assign inscalar24 = 0;

    if(C_NUM_INSCALARS > 25)
        assign inscalar25 = inscalar[25][C_INSCALAR_25_BITS-1:0];
    else
        assign inscalar25 = 0;

    if(C_NUM_INSCALARS > 26)
        assign inscalar26 = inscalar[26][C_INSCALAR_26_BITS-1:0];
    else
        assign inscalar26 = 0;

    if(C_NUM_INSCALARS > 27)
        assign inscalar27 = inscalar[27][C_INSCALAR_27_BITS-1:0];
    else
        assign inscalar27 = 0;

    if(C_NUM_INSCALARS > 28)
        assign inscalar28 = inscalar[28][C_INSCALAR_28_BITS-1:0];
    else
        assign inscalar28 = 0;

    if(C_NUM_INSCALARS > 29)
        assign inscalar29 = inscalar[29][C_INSCALAR_29_BITS-1:0];
    else
        assign inscalar29 = 0;

    if(C_NUM_INSCALARS > 30)
        assign inscalar30 = inscalar[30][C_INSCALAR_30_BITS-1:0];
    else
        assign inscalar30 = 0;

    if(C_NUM_INSCALARS > 31)
        assign inscalar31 = inscalar[31][C_INSCALAR_31_BITS-1:0];
    else
        assign inscalar31 = 0;

    if(C_NUM_INSCALARS > 32)
        assign inscalar32 = inscalar[32][C_INSCALAR_32_BITS-1:0];
    else
        assign inscalar32 = 0;

    if(C_NUM_INSCALARS > 33)
        assign inscalar33 = inscalar[33][C_INSCALAR_33_BITS-1:0];
    else
        assign inscalar33 = 0;

    if(C_NUM_INSCALARS > 34)
        assign inscalar34 = inscalar[34][C_INSCALAR_34_BITS-1:0];
    else
        assign inscalar34 = 0;

    if(C_NUM_INSCALARS > 35)
        assign inscalar35 = inscalar[35][C_INSCALAR_35_BITS-1:0];
    else
        assign inscalar35 = 0;

    if(C_NUM_INSCALARS > 36)
        assign inscalar36 = inscalar[36][C_INSCALAR_36_BITS-1:0];
    else
        assign inscalar36 = 0;

    if(C_NUM_INSCALARS > 37)
        assign inscalar37 = inscalar[37][C_INSCALAR_37_BITS-1:0];
    else
        assign inscalar37 = 0;

    if(C_NUM_INSCALARS > 38)
        assign inscalar38 = inscalar[38][C_INSCALAR_38_BITS-1:0];
    else
        assign inscalar38 = 0;

    if(C_NUM_INSCALARS > 39)
        assign inscalar39 = inscalar[39][C_INSCALAR_39_BITS-1:0];
    else
        assign inscalar39 = 0;

    if(C_NUM_INSCALARS > 40)
        assign inscalar40 = inscalar[40][C_INSCALAR_40_BITS-1:0];
    else
        assign inscalar40 = 0;

    if(C_NUM_INSCALARS > 41)
        assign inscalar41 = inscalar[41][C_INSCALAR_41_BITS-1:0];
    else
        assign inscalar41 = 0;

    if(C_NUM_INSCALARS > 42)
        assign inscalar42 = inscalar[42][C_INSCALAR_42_BITS-1:0];
    else
        assign inscalar42 = 0;

    if(C_NUM_INSCALARS > 43)
        assign inscalar43 = inscalar[43][C_INSCALAR_43_BITS-1:0];
    else
        assign inscalar43 = 0;

    if(C_NUM_INSCALARS > 44)
        assign inscalar44 = inscalar[44][C_INSCALAR_44_BITS-1:0];
    else
        assign inscalar44 = 0;

    if(C_NUM_INSCALARS > 45)
        assign inscalar45 = inscalar[45][C_INSCALAR_45_BITS-1:0];
    else
        assign inscalar45 = 0;

    if(C_NUM_INSCALARS > 46)
        assign inscalar46 = inscalar[46][C_INSCALAR_46_BITS-1:0];
    else
        assign inscalar46 = 0;

    if(C_NUM_INSCALARS > 47)
        assign inscalar47 = inscalar[47][C_INSCALAR_47_BITS-1:0];
    else
        assign inscalar47 = 0;

    if(C_NUM_INSCALARS > 48)
        assign inscalar48 = inscalar[48][C_INSCALAR_48_BITS-1:0];
    else
        assign inscalar48 = 0;

    if(C_NUM_INSCALARS > 49)
        assign inscalar49 = inscalar[49][C_INSCALAR_49_BITS-1:0];
    else
        assign inscalar49 = 0;

    if(C_NUM_INSCALARS > 50)
        assign inscalar50 = inscalar[50][C_INSCALAR_50_BITS-1:0];
    else
        assign inscalar50 = 0;

    if(C_NUM_INSCALARS > 51)
        assign inscalar51 = inscalar[51][C_INSCALAR_51_BITS-1:0];
    else
        assign inscalar51 = 0;

    if(C_NUM_INSCALARS > 52)
        assign inscalar52 = inscalar[52][C_INSCALAR_52_BITS-1:0];
    else
        assign inscalar52 = 0;

    if(C_NUM_INSCALARS > 53)
        assign inscalar53 = inscalar[53][C_INSCALAR_53_BITS-1:0];
    else
        assign inscalar53 = 0;

    if(C_NUM_INSCALARS > 54)
        assign inscalar54 = inscalar[54][C_INSCALAR_54_BITS-1:0];
    else
        assign inscalar54 = 0;

    if(C_NUM_INSCALARS > 55)
        assign inscalar55 = inscalar[55][C_INSCALAR_55_BITS-1:0];
    else
        assign inscalar55 = 0;

    if(C_NUM_INSCALARS > 56)
        assign inscalar56 = inscalar[56][C_INSCALAR_56_BITS-1:0];
    else
        assign inscalar56 = 0;

    if(C_NUM_INSCALARS > 57)
        assign inscalar57 = inscalar[57][C_INSCALAR_57_BITS-1:0];
    else
        assign inscalar57 = 0;

    if(C_NUM_INSCALARS > 58)
        assign inscalar58 = inscalar[58][C_INSCALAR_58_BITS-1:0];
    else
        assign inscalar58 = 0;

    if(C_NUM_INSCALARS > 59)
        assign inscalar59 = inscalar[59][C_INSCALAR_59_BITS-1:0];
    else
        assign inscalar59 = 0;

    if(C_NUM_INSCALARS > 60)
        assign inscalar60 = inscalar[60][C_INSCALAR_60_BITS-1:0];
    else
        assign inscalar60 = 0;

    if(C_NUM_INSCALARS > 61)
        assign inscalar61 = inscalar[61][C_INSCALAR_61_BITS-1:0];
    else
        assign inscalar61 = 0;

    if(C_NUM_INSCALARS > 62)
        assign inscalar62 = inscalar[62][C_INSCALAR_62_BITS-1:0];
    else
        assign inscalar62 = 0;

    if(C_NUM_INSCALARS > 63)
        assign inscalar63 = inscalar[63][C_INSCALAR_63_BITS-1:0];
    else
        assign inscalar63 = 0;

    if(C_NUM_INSCALARS > 64)
        assign inscalar64 = inscalar[64][C_INSCALAR_64_BITS-1:0];
    else
        assign inscalar64 = 0;

    if(C_NUM_INSCALARS > 65)
        assign inscalar65 = inscalar[65][C_INSCALAR_65_BITS-1:0];
    else
        assign inscalar65 = 0;

    if(C_NUM_INSCALARS > 66)
        assign inscalar66 = inscalar[66][C_INSCALAR_66_BITS-1:0];
    else
        assign inscalar66 = 0;

    if(C_NUM_INSCALARS > 67)
        assign inscalar67 = inscalar[67][C_INSCALAR_67_BITS-1:0];
    else
        assign inscalar67 = 0;

    if(C_NUM_INSCALARS > 68)
        assign inscalar68 = inscalar[68][C_INSCALAR_68_BITS-1:0];
    else
        assign inscalar68 = 0;

    if(C_NUM_INSCALARS > 69)
        assign inscalar69 = inscalar[69][C_INSCALAR_69_BITS-1:0];
    else
        assign inscalar69 = 0;

    if(C_NUM_INSCALARS > 70)
        assign inscalar70 = inscalar[70][C_INSCALAR_70_BITS-1:0];
    else
        assign inscalar70 = 0;

    if(C_NUM_INSCALARS > 71)
        assign inscalar71 = inscalar[71][C_INSCALAR_71_BITS-1:0];
    else
        assign inscalar71 = 0;

    if(C_NUM_INSCALARS > 72)
        assign inscalar72 = inscalar[72][C_INSCALAR_72_BITS-1:0];
    else
        assign inscalar72 = 0;

    if(C_NUM_INSCALARS > 73)
        assign inscalar73 = inscalar[73][C_INSCALAR_73_BITS-1:0];
    else
        assign inscalar73 = 0;

    if(C_NUM_INSCALARS > 74)
        assign inscalar74 = inscalar[74][C_INSCALAR_74_BITS-1:0];
    else
        assign inscalar74 = 0;

    if(C_NUM_INSCALARS > 75)
        assign inscalar75 = inscalar[75][C_INSCALAR_75_BITS-1:0];
    else
        assign inscalar75 = 0;

    if(C_NUM_INSCALARS > 76)
        assign inscalar76 = inscalar[76][C_INSCALAR_76_BITS-1:0];
    else
        assign inscalar76 = 0;

    if(C_NUM_INSCALARS > 77)
        assign inscalar77 = inscalar[77][C_INSCALAR_77_BITS-1:0];
    else
        assign inscalar77 = 0;

    if(C_NUM_INSCALARS > 78)
        assign inscalar78 = inscalar[78][C_INSCALAR_78_BITS-1:0];
    else
        assign inscalar78 = 0;

    if(C_NUM_INSCALARS > 79)
        assign inscalar79 = inscalar[79][C_INSCALAR_79_BITS-1:0];
    else
        assign inscalar79 = 0;

    if(C_NUM_INSCALARS > 80)
        assign inscalar80 = inscalar[80][C_INSCALAR_80_BITS-1:0];
    else
        assign inscalar80 = 0;

    if(C_NUM_INSCALARS > 81)
        assign inscalar81 = inscalar[81][C_INSCALAR_81_BITS-1:0];
    else
        assign inscalar81 = 0;

    if(C_NUM_INSCALARS > 82)
        assign inscalar82 = inscalar[82][C_INSCALAR_82_BITS-1:0];
    else
        assign inscalar82 = 0;

    if(C_NUM_INSCALARS > 83)
        assign inscalar83 = inscalar[83][C_INSCALAR_83_BITS-1:0];
    else
        assign inscalar83 = 0;

    if(C_NUM_INSCALARS > 84)
        assign inscalar84 = inscalar[84][C_INSCALAR_84_BITS-1:0];
    else
        assign inscalar84 = 0;

    if(C_NUM_INSCALARS > 85)
        assign inscalar85 = inscalar[85][C_INSCALAR_85_BITS-1:0];
    else
        assign inscalar85 = 0;

    if(C_NUM_INSCALARS > 86)
        assign inscalar86 = inscalar[86][C_INSCALAR_86_BITS-1:0];
    else
        assign inscalar86 = 0;

    if(C_NUM_INSCALARS > 87)
        assign inscalar87 = inscalar[87][C_INSCALAR_87_BITS-1:0];
    else
        assign inscalar87 = 0;

    if(C_NUM_INSCALARS > 88)
        assign inscalar88 = inscalar[88][C_INSCALAR_88_BITS-1:0];
    else
        assign inscalar88 = 0;

    if(C_NUM_INSCALARS > 89)
        assign inscalar89 = inscalar[89][C_INSCALAR_89_BITS-1:0];
    else
        assign inscalar89 = 0;

    if(C_NUM_INSCALARS > 90)
        assign inscalar90 = inscalar[90][C_INSCALAR_90_BITS-1:0];
    else
        assign inscalar90 = 0;

    if(C_NUM_INSCALARS > 91)
        assign inscalar91 = inscalar[91][C_INSCALAR_91_BITS-1:0];
    else
        assign inscalar91 = 0;

    if(C_NUM_INSCALARS > 92)
        assign inscalar92 = inscalar[92][C_INSCALAR_92_BITS-1:0];
    else
        assign inscalar92 = 0;

    if(C_NUM_INSCALARS > 93)
        assign inscalar93 = inscalar[93][C_INSCALAR_93_BITS-1:0];
    else
        assign inscalar93 = 0;

    if(C_NUM_INSCALARS > 94)
        assign inscalar94 = inscalar[94][C_INSCALAR_94_BITS-1:0];
    else
        assign inscalar94 = 0;

    if(C_NUM_INSCALARS > 95)
        assign inscalar95 = inscalar[95][C_INSCALAR_95_BITS-1:0];
    else
        assign inscalar95 = 0;

    if(C_NUM_INSCALARS > 96)
        assign inscalar96 = inscalar[96][C_INSCALAR_96_BITS-1:0];
    else
        assign inscalar96 = 0;

    if(C_NUM_INSCALARS > 97)
        assign inscalar97 = inscalar[97][C_INSCALAR_97_BITS-1:0];
    else
        assign inscalar97 = 0;

    if(C_NUM_INSCALARS > 98)
        assign inscalar98 = inscalar[98][C_INSCALAR_98_BITS-1:0];
    else
        assign inscalar98 = 0;

    if(C_NUM_INSCALARS > 99)
        assign inscalar99 = inscalar[99][C_INSCALAR_99_BITS-1:0];
    else
        assign inscalar99 = 0;

    if(C_NUM_INSCALARS > 100)
        assign inscalar100 = inscalar[100][C_INSCALAR_100_BITS-1:0];
    else
        assign inscalar100 = 0;

    if(C_NUM_INSCALARS > 101)
        assign inscalar101 = inscalar[101][C_INSCALAR_101_BITS-1:0];
    else
        assign inscalar101 = 0;

    if(C_NUM_INSCALARS > 102)
        assign inscalar102 = inscalar[102][C_INSCALAR_102_BITS-1:0];
    else
        assign inscalar102 = 0;

    if(C_NUM_INSCALARS > 103)
        assign inscalar103 = inscalar[103][C_INSCALAR_103_BITS-1:0];
    else
        assign inscalar103 = 0;

    if(C_NUM_INSCALARS > 104)
        assign inscalar104 = inscalar[104][C_INSCALAR_104_BITS-1:0];
    else
        assign inscalar104 = 0;

    if(C_NUM_INSCALARS > 105)
        assign inscalar105 = inscalar[105][C_INSCALAR_105_BITS-1:0];
    else
        assign inscalar105 = 0;

    if(C_NUM_INSCALARS > 106)
        assign inscalar106 = inscalar[106][C_INSCALAR_106_BITS-1:0];
    else
        assign inscalar106 = 0;

    if(C_NUM_INSCALARS > 107)
        assign inscalar107 = inscalar[107][C_INSCALAR_107_BITS-1:0];
    else
        assign inscalar107 = 0;

    if(C_NUM_INSCALARS > 108)
        assign inscalar108 = inscalar[108][C_INSCALAR_108_BITS-1:0];
    else
        assign inscalar108 = 0;

    if(C_NUM_INSCALARS > 109)
        assign inscalar109 = inscalar[109][C_INSCALAR_109_BITS-1:0];
    else
        assign inscalar109 = 0;

    if(C_NUM_INSCALARS > 110)
        assign inscalar110 = inscalar[110][C_INSCALAR_110_BITS-1:0];
    else
        assign inscalar110 = 0;

    if(C_NUM_INSCALARS > 111)
        assign inscalar111 = inscalar[111][C_INSCALAR_111_BITS-1:0];
    else
        assign inscalar111 = 0;

    if(C_NUM_INSCALARS > 112)
        assign inscalar112 = inscalar[112][C_INSCALAR_112_BITS-1:0];
    else
        assign inscalar112 = 0;

    if(C_NUM_INSCALARS > 113)
        assign inscalar113 = inscalar[113][C_INSCALAR_113_BITS-1:0];
    else
        assign inscalar113 = 0;

    if(C_NUM_INSCALARS > 114)
        assign inscalar114 = inscalar[114][C_INSCALAR_114_BITS-1:0];
    else
        assign inscalar114 = 0;

    if(C_NUM_INSCALARS > 115)
        assign inscalar115 = inscalar[115][C_INSCALAR_115_BITS-1:0];
    else
        assign inscalar115 = 0;

    if(C_NUM_INSCALARS > 116)
        assign inscalar116 = inscalar[116][C_INSCALAR_116_BITS-1:0];
    else
        assign inscalar116 = 0;

    if(C_NUM_INSCALARS > 117)
        assign inscalar117 = inscalar[117][C_INSCALAR_117_BITS-1:0];
    else
        assign inscalar117 = 0;

    if(C_NUM_INSCALARS > 118)
        assign inscalar118 = inscalar[118][C_INSCALAR_118_BITS-1:0];
    else
        assign inscalar118 = 0;

    if(C_NUM_INSCALARS > 119)
        assign inscalar119 = inscalar[119][C_INSCALAR_119_BITS-1:0];
    else
        assign inscalar119 = 0;

    if(C_NUM_INSCALARS > 120)
        assign inscalar120 = inscalar[120][C_INSCALAR_120_BITS-1:0];
    else
        assign inscalar120 = 0;

    if(C_NUM_INSCALARS > 121)
        assign inscalar121 = inscalar[121][C_INSCALAR_121_BITS-1:0];
    else
        assign inscalar121 = 0;

    if(C_NUM_INSCALARS > 122)
        assign inscalar122 = inscalar[122][C_INSCALAR_122_BITS-1:0];
    else
        assign inscalar122 = 0;

    if(C_NUM_INSCALARS > 123)
        assign inscalar123 = inscalar[123][C_INSCALAR_123_BITS-1:0];
    else
        assign inscalar123 = 0;

    if(C_NUM_INSCALARS > 124)
        assign inscalar124 = inscalar[124][C_INSCALAR_124_BITS-1:0];
    else
        assign inscalar124 = 0;

    if(C_NUM_INSCALARS > 125)
        assign inscalar125 = inscalar[125][C_INSCALAR_125_BITS-1:0];
    else
        assign inscalar125 = 0;

    if(C_NUM_INSCALARS > 126)
        assign inscalar126 = inscalar[126][C_INSCALAR_126_BITS-1:0];
    else
        assign inscalar126 = 0;

    if(C_NUM_INSCALARS > 127)
        assign inscalar127 = inscalar[127][C_INSCALAR_127_BITS-1:0];
    else
        assign inscalar127 = 0;

endgenerate

//map output scalar data values from ports to register
generate
    if(C_NUM_OUTSCALARS > 0) begin
        assign outscalar[0][C_OUTSCALAR_0_BITS-1:0] = outscalar0;
        if(C_HAS_RETURN > 0)
            assign outscalar_vld[0] = outscalar_capture;
        else
            assign outscalar_vld[0] = outscalar0_vld;
    end
    if(C_NUM_OUTSCALARS > 1) begin
        assign outscalar[1][C_OUTSCALAR_1_BITS-1:0] = outscalar1;
        assign outscalar_vld[1] = outscalar1_vld;
    end
    if(C_NUM_OUTSCALARS > 2) begin
        assign outscalar[2][C_OUTSCALAR_2_BITS-1:0] = outscalar2;
        assign outscalar_vld[2] = outscalar2_vld;
    end
    if(C_NUM_OUTSCALARS > 3) begin
        assign outscalar[3][C_OUTSCALAR_3_BITS-1:0] = outscalar3;
        assign outscalar_vld[3] = outscalar3_vld;
    end
    if(C_NUM_OUTSCALARS > 4) begin
        assign outscalar[4][C_OUTSCALAR_4_BITS-1:0] = outscalar4;
        assign outscalar_vld[4] = outscalar4_vld;
    end
    if(C_NUM_OUTSCALARS > 5) begin
        assign outscalar[5][C_OUTSCALAR_5_BITS-1:0] = outscalar5;
        assign outscalar_vld[5] = outscalar5_vld;
    end
    if(C_NUM_OUTSCALARS > 6) begin
        assign outscalar[6][C_OUTSCALAR_6_BITS-1:0] = outscalar6;
        assign outscalar_vld[6] = outscalar6_vld;
    end
    if(C_NUM_OUTSCALARS > 7) begin
        assign outscalar[7][C_OUTSCALAR_7_BITS-1:0] = outscalar7;
        assign outscalar_vld[7] = outscalar7_vld;
    end
    if(C_NUM_OUTSCALARS > 8) begin
        assign outscalar[8][C_OUTSCALAR_8_BITS-1:0] = outscalar8;
        assign outscalar_vld[8] = outscalar8_vld;
    end
    if(C_NUM_OUTSCALARS > 9) begin
        assign outscalar[9][C_OUTSCALAR_9_BITS-1:0] = outscalar9;
        assign outscalar_vld[9] = outscalar9_vld;
    end
    if(C_NUM_OUTSCALARS > 10) begin
        assign outscalar[10][C_OUTSCALAR_10_BITS-1:0] = outscalar10;
        assign outscalar_vld[10] = outscalar10_vld;
    end
    if(C_NUM_OUTSCALARS > 11) begin
        assign outscalar[11][C_OUTSCALAR_11_BITS-1:0] = outscalar11;
        assign outscalar_vld[11] = outscalar11_vld;
    end
    if(C_NUM_OUTSCALARS > 12) begin
        assign outscalar[12][C_OUTSCALAR_12_BITS-1:0] = outscalar12;
        assign outscalar_vld[12] = outscalar12_vld;
    end
    if(C_NUM_OUTSCALARS > 13) begin
        assign outscalar[13][C_OUTSCALAR_13_BITS-1:0] = outscalar13;
        assign outscalar_vld[13] = outscalar13_vld;
    end
    if(C_NUM_OUTSCALARS > 14) begin
        assign outscalar[14][C_OUTSCALAR_14_BITS-1:0] = outscalar14;
        assign outscalar_vld[14] = outscalar14_vld;
    end
    if(C_NUM_OUTSCALARS > 15) begin
        assign outscalar[15][C_OUTSCALAR_15_BITS-1:0] = outscalar15;
        assign outscalar_vld[15] = outscalar15_vld;
    end
    if(C_NUM_OUTSCALARS > 16) begin
        assign outscalar[16][C_OUTSCALAR_16_BITS-1:0] = outscalar16;
        assign outscalar_vld[16] = outscalar16_vld;
    end
    if(C_NUM_OUTSCALARS > 17) begin
        assign outscalar[17][C_OUTSCALAR_17_BITS-1:0] = outscalar17;
        assign outscalar_vld[17] = outscalar17_vld;
    end
    if(C_NUM_OUTSCALARS > 18) begin
        assign outscalar[18][C_OUTSCALAR_18_BITS-1:0] = outscalar18;
        assign outscalar_vld[18] = outscalar18_vld;
    end
    if(C_NUM_OUTSCALARS > 19) begin
        assign outscalar[19][C_OUTSCALAR_19_BITS-1:0] = outscalar19;
        assign outscalar_vld[19] = outscalar19_vld;
    end
    if(C_NUM_OUTSCALARS > 20) begin
        assign outscalar[20][C_OUTSCALAR_20_BITS-1:0] = outscalar20;
        assign outscalar_vld[20] = outscalar20_vld;
    end
    if(C_NUM_OUTSCALARS > 21) begin
        assign outscalar[21][C_OUTSCALAR_21_BITS-1:0] = outscalar21;
        assign outscalar_vld[21] = outscalar21_vld;
    end
    if(C_NUM_OUTSCALARS > 22) begin
        assign outscalar[22][C_OUTSCALAR_22_BITS-1:0] = outscalar22;
        assign outscalar_vld[22] = outscalar22_vld;
    end
    if(C_NUM_OUTSCALARS > 23) begin
        assign outscalar[23][C_OUTSCALAR_23_BITS-1:0] = outscalar23;
        assign outscalar_vld[23] = outscalar23_vld;
    end
    if(C_NUM_OUTSCALARS > 24) begin
        assign outscalar[24][C_OUTSCALAR_24_BITS-1:0] = outscalar24;
        assign outscalar_vld[24] = outscalar24_vld;
    end
    if(C_NUM_OUTSCALARS > 25) begin
        assign outscalar[25][C_OUTSCALAR_25_BITS-1:0] = outscalar25;
        assign outscalar_vld[25] = outscalar25_vld;
    end
    if(C_NUM_OUTSCALARS > 26) begin
        assign outscalar[26][C_OUTSCALAR_26_BITS-1:0] = outscalar26;
        assign outscalar_vld[26] = outscalar26_vld;
    end
    if(C_NUM_OUTSCALARS > 27) begin
        assign outscalar[27][C_OUTSCALAR_27_BITS-1:0] = outscalar27;
        assign outscalar_vld[27] = outscalar27_vld;
    end
    if(C_NUM_OUTSCALARS > 28) begin
        assign outscalar[28][C_OUTSCALAR_28_BITS-1:0] = outscalar28;
        assign outscalar_vld[28] = outscalar28_vld;
    end
    if(C_NUM_OUTSCALARS > 29) begin
        assign outscalar[29][C_OUTSCALAR_29_BITS-1:0] = outscalar29;
        assign outscalar_vld[29] = outscalar29_vld;
    end
    if(C_NUM_OUTSCALARS > 30) begin
        assign outscalar[30][C_OUTSCALAR_30_BITS-1:0] = outscalar30;
        assign outscalar_vld[30] = outscalar30_vld;
    end
    if(C_NUM_OUTSCALARS > 31) begin
        assign outscalar[31][C_OUTSCALAR_31_BITS-1:0] = outscalar31;
        assign outscalar_vld[31] = outscalar31_vld;
    end
    if(C_NUM_OUTSCALARS > 32) begin
        assign outscalar[32][C_OUTSCALAR_32_BITS-1:0] = outscalar32;
        assign outscalar_vld[32] = outscalar32_vld;
    end
    if(C_NUM_OUTSCALARS > 33) begin
        assign outscalar[33][C_OUTSCALAR_33_BITS-1:0] = outscalar33;
        assign outscalar_vld[33] = outscalar33_vld;
    end
    if(C_NUM_OUTSCALARS > 34) begin
        assign outscalar[34][C_OUTSCALAR_34_BITS-1:0] = outscalar34;
        assign outscalar_vld[34] = outscalar34_vld;
    end
    if(C_NUM_OUTSCALARS > 35) begin
        assign outscalar[35][C_OUTSCALAR_35_BITS-1:0] = outscalar35;
        assign outscalar_vld[35] = outscalar35_vld;
    end
    if(C_NUM_OUTSCALARS > 36) begin
        assign outscalar[36][C_OUTSCALAR_36_BITS-1:0] = outscalar36;
        assign outscalar_vld[36] = outscalar36_vld;
    end
    if(C_NUM_OUTSCALARS > 37) begin
        assign outscalar[37][C_OUTSCALAR_37_BITS-1:0] = outscalar37;
        assign outscalar_vld[37] = outscalar37_vld;
    end
    if(C_NUM_OUTSCALARS > 38) begin
        assign outscalar[38][C_OUTSCALAR_38_BITS-1:0] = outscalar38;
        assign outscalar_vld[38] = outscalar38_vld;
    end
    if(C_NUM_OUTSCALARS > 39) begin
        assign outscalar[39][C_OUTSCALAR_39_BITS-1:0] = outscalar39;
        assign outscalar_vld[39] = outscalar39_vld;
    end
    if(C_NUM_OUTSCALARS > 40) begin
        assign outscalar[40][C_OUTSCALAR_40_BITS-1:0] = outscalar40;
        assign outscalar_vld[40] = outscalar40_vld;
    end
    if(C_NUM_OUTSCALARS > 41) begin
        assign outscalar[41][C_OUTSCALAR_41_BITS-1:0] = outscalar41;
        assign outscalar_vld[41] = outscalar41_vld;
    end
    if(C_NUM_OUTSCALARS > 42) begin
        assign outscalar[42][C_OUTSCALAR_42_BITS-1:0] = outscalar42;
        assign outscalar_vld[42] = outscalar42_vld;
    end
    if(C_NUM_OUTSCALARS > 43) begin
        assign outscalar[43][C_OUTSCALAR_43_BITS-1:0] = outscalar43;
        assign outscalar_vld[43] = outscalar43_vld;
    end
    if(C_NUM_OUTSCALARS > 44) begin
        assign outscalar[44][C_OUTSCALAR_44_BITS-1:0] = outscalar44;
        assign outscalar_vld[44] = outscalar44_vld;
    end
    if(C_NUM_OUTSCALARS > 45) begin
        assign outscalar[45][C_OUTSCALAR_45_BITS-1:0] = outscalar45;
        assign outscalar_vld[45] = outscalar45_vld;
    end
    if(C_NUM_OUTSCALARS > 46) begin
        assign outscalar[46][C_OUTSCALAR_46_BITS-1:0] = outscalar46;
        assign outscalar_vld[46] = outscalar46_vld;
    end
    if(C_NUM_OUTSCALARS > 47) begin
        assign outscalar[47][C_OUTSCALAR_47_BITS-1:0] = outscalar47;
        assign outscalar_vld[47] = outscalar47_vld;
    end
    if(C_NUM_OUTSCALARS > 48) begin
        assign outscalar[48][C_OUTSCALAR_48_BITS-1:0] = outscalar48;
        assign outscalar_vld[48] = outscalar48_vld;
    end
    if(C_NUM_OUTSCALARS > 49) begin
        assign outscalar[49][C_OUTSCALAR_49_BITS-1:0] = outscalar49;
        assign outscalar_vld[49] = outscalar49_vld;
    end
    if(C_NUM_OUTSCALARS > 50) begin
        assign outscalar[50][C_OUTSCALAR_50_BITS-1:0] = outscalar50;
        assign outscalar_vld[50] = outscalar50_vld;
    end
    if(C_NUM_OUTSCALARS > 51) begin
        assign outscalar[51][C_OUTSCALAR_51_BITS-1:0] = outscalar51;
        assign outscalar_vld[51] = outscalar51_vld;
    end
    if(C_NUM_OUTSCALARS > 52) begin
        assign outscalar[52][C_OUTSCALAR_52_BITS-1:0] = outscalar52;
        assign outscalar_vld[52] = outscalar52_vld;
    end
    if(C_NUM_OUTSCALARS > 53) begin
        assign outscalar[53][C_OUTSCALAR_53_BITS-1:0] = outscalar53;
        assign outscalar_vld[53] = outscalar53_vld;
    end
    if(C_NUM_OUTSCALARS > 54) begin
        assign outscalar[54][C_OUTSCALAR_54_BITS-1:0] = outscalar54;
        assign outscalar_vld[54] = outscalar54_vld;
    end
    if(C_NUM_OUTSCALARS > 55) begin
        assign outscalar[55][C_OUTSCALAR_55_BITS-1:0] = outscalar55;
        assign outscalar_vld[55] = outscalar55_vld;
    end
    if(C_NUM_OUTSCALARS > 56) begin
        assign outscalar[56][C_OUTSCALAR_56_BITS-1:0] = outscalar56;
        assign outscalar_vld[56] = outscalar56_vld;
    end
    if(C_NUM_OUTSCALARS > 57) begin
        assign outscalar[57][C_OUTSCALAR_57_BITS-1:0] = outscalar57;
        assign outscalar_vld[57] = outscalar57_vld;
    end
    if(C_NUM_OUTSCALARS > 58) begin
        assign outscalar[58][C_OUTSCALAR_58_BITS-1:0] = outscalar58;
        assign outscalar_vld[58] = outscalar58_vld;
    end
    if(C_NUM_OUTSCALARS > 59) begin
        assign outscalar[59][C_OUTSCALAR_59_BITS-1:0] = outscalar59;
        assign outscalar_vld[59] = outscalar59_vld;
    end
    if(C_NUM_OUTSCALARS > 60) begin
        assign outscalar[60][C_OUTSCALAR_60_BITS-1:0] = outscalar60;
        assign outscalar_vld[60] = outscalar60_vld;
    end
    if(C_NUM_OUTSCALARS > 61) begin
        assign outscalar[61][C_OUTSCALAR_61_BITS-1:0] = outscalar61;
        assign outscalar_vld[61] = outscalar61_vld;
    end
    if(C_NUM_OUTSCALARS > 62) begin
        assign outscalar[62][C_OUTSCALAR_62_BITS-1:0] = outscalar62;
        assign outscalar_vld[62] = outscalar62_vld;
    end
    if(C_NUM_OUTSCALARS > 63) begin
        assign outscalar[63][C_OUTSCALAR_63_BITS-1:0] = outscalar63;
        assign outscalar_vld[63] = outscalar63_vld;
    end
    if(C_NUM_OUTSCALARS > 64) begin
        assign outscalar[64][C_OUTSCALAR_64_BITS-1:0] = outscalar64;
        assign outscalar_vld[64] = outscalar64_vld;
    end
    if(C_NUM_OUTSCALARS > 65) begin
        assign outscalar[65][C_OUTSCALAR_65_BITS-1:0] = outscalar65;
        assign outscalar_vld[65] = outscalar65_vld;
    end
    if(C_NUM_OUTSCALARS > 66) begin
        assign outscalar[66][C_OUTSCALAR_66_BITS-1:0] = outscalar66;
        assign outscalar_vld[66] = outscalar66_vld;
    end
    if(C_NUM_OUTSCALARS > 67) begin
        assign outscalar[67][C_OUTSCALAR_67_BITS-1:0] = outscalar67;
        assign outscalar_vld[67] = outscalar67_vld;
    end
    if(C_NUM_OUTSCALARS > 68) begin
        assign outscalar[68][C_OUTSCALAR_68_BITS-1:0] = outscalar68;
        assign outscalar_vld[68] = outscalar68_vld;
    end
    if(C_NUM_OUTSCALARS > 69) begin
        assign outscalar[69][C_OUTSCALAR_69_BITS-1:0] = outscalar69;
        assign outscalar_vld[69] = outscalar69_vld;
    end
    if(C_NUM_OUTSCALARS > 70) begin
        assign outscalar[70][C_OUTSCALAR_70_BITS-1:0] = outscalar70;
        assign outscalar_vld[70] = outscalar70_vld;
    end
    if(C_NUM_OUTSCALARS > 71) begin
        assign outscalar[71][C_OUTSCALAR_71_BITS-1:0] = outscalar71;
        assign outscalar_vld[71] = outscalar71_vld;
    end
    if(C_NUM_OUTSCALARS > 72) begin
        assign outscalar[72][C_OUTSCALAR_72_BITS-1:0] = outscalar72;
        assign outscalar_vld[72] = outscalar72_vld;
    end
    if(C_NUM_OUTSCALARS > 73) begin
        assign outscalar[73][C_OUTSCALAR_73_BITS-1:0] = outscalar73;
        assign outscalar_vld[73] = outscalar73_vld;
    end
    if(C_NUM_OUTSCALARS > 74) begin
        assign outscalar[74][C_OUTSCALAR_74_BITS-1:0] = outscalar74;
        assign outscalar_vld[74] = outscalar74_vld;
    end
    if(C_NUM_OUTSCALARS > 75) begin
        assign outscalar[75][C_OUTSCALAR_75_BITS-1:0] = outscalar75;
        assign outscalar_vld[75] = outscalar75_vld;
    end
    if(C_NUM_OUTSCALARS > 76) begin
        assign outscalar[76][C_OUTSCALAR_76_BITS-1:0] = outscalar76;
        assign outscalar_vld[76] = outscalar76_vld;
    end
    if(C_NUM_OUTSCALARS > 77) begin
        assign outscalar[77][C_OUTSCALAR_77_BITS-1:0] = outscalar77;
        assign outscalar_vld[77] = outscalar77_vld;
    end
    if(C_NUM_OUTSCALARS > 78) begin
        assign outscalar[78][C_OUTSCALAR_78_BITS-1:0] = outscalar78;
        assign outscalar_vld[78] = outscalar78_vld;
    end
    if(C_NUM_OUTSCALARS > 79) begin
        assign outscalar[79][C_OUTSCALAR_79_BITS-1:0] = outscalar79;
        assign outscalar_vld[79] = outscalar79_vld;
    end
    if(C_NUM_OUTSCALARS > 80) begin
        assign outscalar[80][C_OUTSCALAR_80_BITS-1:0] = outscalar80;
        assign outscalar_vld[80] = outscalar80_vld;
    end
    if(C_NUM_OUTSCALARS > 81) begin
        assign outscalar[81][C_OUTSCALAR_81_BITS-1:0] = outscalar81;
        assign outscalar_vld[81] = outscalar81_vld;
    end
    if(C_NUM_OUTSCALARS > 82) begin
        assign outscalar[82][C_OUTSCALAR_82_BITS-1:0] = outscalar82;
        assign outscalar_vld[82] = outscalar82_vld;
    end
    if(C_NUM_OUTSCALARS > 83) begin
        assign outscalar[83][C_OUTSCALAR_83_BITS-1:0] = outscalar83;
        assign outscalar_vld[83] = outscalar83_vld;
    end
    if(C_NUM_OUTSCALARS > 84) begin
        assign outscalar[84][C_OUTSCALAR_84_BITS-1:0] = outscalar84;
        assign outscalar_vld[84] = outscalar84_vld;
    end
    if(C_NUM_OUTSCALARS > 85) begin
        assign outscalar[85][C_OUTSCALAR_85_BITS-1:0] = outscalar85;
        assign outscalar_vld[85] = outscalar85_vld;
    end
    if(C_NUM_OUTSCALARS > 86) begin
        assign outscalar[86][C_OUTSCALAR_86_BITS-1:0] = outscalar86;
        assign outscalar_vld[86] = outscalar86_vld;
    end
    if(C_NUM_OUTSCALARS > 87) begin
        assign outscalar[87][C_OUTSCALAR_87_BITS-1:0] = outscalar87;
        assign outscalar_vld[87] = outscalar87_vld;
    end
    if(C_NUM_OUTSCALARS > 88) begin
        assign outscalar[88][C_OUTSCALAR_88_BITS-1:0] = outscalar88;
        assign outscalar_vld[88] = outscalar88_vld;
    end
    if(C_NUM_OUTSCALARS > 89) begin
        assign outscalar[89][C_OUTSCALAR_89_BITS-1:0] = outscalar89;
        assign outscalar_vld[89] = outscalar89_vld;
    end
    if(C_NUM_OUTSCALARS > 90) begin
        assign outscalar[90][C_OUTSCALAR_90_BITS-1:0] = outscalar90;
        assign outscalar_vld[90] = outscalar90_vld;
    end
    if(C_NUM_OUTSCALARS > 91) begin
        assign outscalar[91][C_OUTSCALAR_91_BITS-1:0] = outscalar91;
        assign outscalar_vld[91] = outscalar91_vld;
    end
    if(C_NUM_OUTSCALARS > 92) begin
        assign outscalar[92][C_OUTSCALAR_92_BITS-1:0] = outscalar92;
        assign outscalar_vld[92] = outscalar92_vld;
    end
    if(C_NUM_OUTSCALARS > 93) begin
        assign outscalar[93][C_OUTSCALAR_93_BITS-1:0] = outscalar93;
        assign outscalar_vld[93] = outscalar93_vld;
    end
    if(C_NUM_OUTSCALARS > 94) begin
        assign outscalar[94][C_OUTSCALAR_94_BITS-1:0] = outscalar94;
        assign outscalar_vld[94] = outscalar94_vld;
    end
    if(C_NUM_OUTSCALARS > 95) begin
        assign outscalar[95][C_OUTSCALAR_95_BITS-1:0] = outscalar95;
        assign outscalar_vld[95] = outscalar95_vld;
    end
    if(C_NUM_OUTSCALARS > 96) begin
        assign outscalar[96][C_OUTSCALAR_96_BITS-1:0] = outscalar96;
        assign outscalar_vld[96] = outscalar96_vld;
    end
    if(C_NUM_OUTSCALARS > 97) begin
        assign outscalar[97][C_OUTSCALAR_97_BITS-1:0] = outscalar97;
        assign outscalar_vld[97] = outscalar97_vld;
    end
    if(C_NUM_OUTSCALARS > 98) begin
        assign outscalar[98][C_OUTSCALAR_98_BITS-1:0] = outscalar98;
        assign outscalar_vld[98] = outscalar98_vld;
    end
    if(C_NUM_OUTSCALARS > 99) begin
        assign outscalar[99][C_OUTSCALAR_99_BITS-1:0] = outscalar99;
        assign outscalar_vld[99] = outscalar99_vld;
    end
    if(C_NUM_OUTSCALARS > 100) begin
        assign outscalar[100][C_OUTSCALAR_100_BITS-1:0] = outscalar100;
        assign outscalar_vld[100] = outscalar100_vld;
    end
    if(C_NUM_OUTSCALARS > 101) begin
        assign outscalar[101][C_OUTSCALAR_101_BITS-1:0] = outscalar101;
        assign outscalar_vld[101] = outscalar101_vld;
    end
    if(C_NUM_OUTSCALARS > 102) begin
        assign outscalar[102][C_OUTSCALAR_102_BITS-1:0] = outscalar102;
        assign outscalar_vld[102] = outscalar102_vld;
    end
    if(C_NUM_OUTSCALARS > 103) begin
        assign outscalar[103][C_OUTSCALAR_103_BITS-1:0] = outscalar103;
        assign outscalar_vld[103] = outscalar103_vld;
    end
    if(C_NUM_OUTSCALARS > 104) begin
        assign outscalar[104][C_OUTSCALAR_104_BITS-1:0] = outscalar104;
        assign outscalar_vld[104] = outscalar104_vld;
    end
    if(C_NUM_OUTSCALARS > 105) begin
        assign outscalar[105][C_OUTSCALAR_105_BITS-1:0] = outscalar105;
        assign outscalar_vld[105] = outscalar105_vld;
    end
    if(C_NUM_OUTSCALARS > 106) begin
        assign outscalar[106][C_OUTSCALAR_106_BITS-1:0] = outscalar106;
        assign outscalar_vld[106] = outscalar106_vld;
    end
    if(C_NUM_OUTSCALARS > 107) begin
        assign outscalar[107][C_OUTSCALAR_107_BITS-1:0] = outscalar107;
        assign outscalar_vld[107] = outscalar107_vld;
    end
    if(C_NUM_OUTSCALARS > 108) begin
        assign outscalar[108][C_OUTSCALAR_108_BITS-1:0] = outscalar108;
        assign outscalar_vld[108] = outscalar108_vld;
    end
    if(C_NUM_OUTSCALARS > 109) begin
        assign outscalar[109][C_OUTSCALAR_109_BITS-1:0] = outscalar109;
        assign outscalar_vld[109] = outscalar109_vld;
    end
    if(C_NUM_OUTSCALARS > 110) begin
        assign outscalar[110][C_OUTSCALAR_110_BITS-1:0] = outscalar110;
        assign outscalar_vld[110] = outscalar110_vld;
    end
    if(C_NUM_OUTSCALARS > 111) begin
        assign outscalar[111][C_OUTSCALAR_111_BITS-1:0] = outscalar111;
        assign outscalar_vld[111] = outscalar111_vld;
    end
    if(C_NUM_OUTSCALARS > 112) begin
        assign outscalar[112][C_OUTSCALAR_112_BITS-1:0] = outscalar112;
        assign outscalar_vld[112] = outscalar112_vld;
    end
    if(C_NUM_OUTSCALARS > 113) begin
        assign outscalar[113][C_OUTSCALAR_113_BITS-1:0] = outscalar113;
        assign outscalar_vld[113] = outscalar113_vld;
    end
    if(C_NUM_OUTSCALARS > 114) begin
        assign outscalar[114][C_OUTSCALAR_114_BITS-1:0] = outscalar114;
        assign outscalar_vld[114] = outscalar114_vld;
    end
    if(C_NUM_OUTSCALARS > 115) begin
        assign outscalar[115][C_OUTSCALAR_115_BITS-1:0] = outscalar115;
        assign outscalar_vld[115] = outscalar115_vld;
    end
    if(C_NUM_OUTSCALARS > 116) begin
        assign outscalar[116][C_OUTSCALAR_116_BITS-1:0] = outscalar116;
        assign outscalar_vld[116] = outscalar116_vld;
    end
    if(C_NUM_OUTSCALARS > 117) begin
        assign outscalar[117][C_OUTSCALAR_117_BITS-1:0] = outscalar117;
        assign outscalar_vld[117] = outscalar117_vld;
    end
    if(C_NUM_OUTSCALARS > 118) begin
        assign outscalar[118][C_OUTSCALAR_118_BITS-1:0] = outscalar118;
        assign outscalar_vld[118] = outscalar118_vld;
    end
    if(C_NUM_OUTSCALARS > 119) begin
        assign outscalar[119][C_OUTSCALAR_119_BITS-1:0] = outscalar119;
        assign outscalar_vld[119] = outscalar119_vld;
    end
    if(C_NUM_OUTSCALARS > 120) begin
        assign outscalar[120][C_OUTSCALAR_120_BITS-1:0] = outscalar120;
        assign outscalar_vld[120] = outscalar120_vld;
    end
    if(C_NUM_OUTSCALARS > 121) begin
        assign outscalar[121][C_OUTSCALAR_121_BITS-1:0] = outscalar121;
        assign outscalar_vld[121] = outscalar121_vld;
    end
    if(C_NUM_OUTSCALARS > 122) begin
        assign outscalar[122][C_OUTSCALAR_122_BITS-1:0] = outscalar122;
        assign outscalar_vld[122] = outscalar122_vld;
    end
    if(C_NUM_OUTSCALARS > 123) begin
        assign outscalar[123][C_OUTSCALAR_123_BITS-1:0] = outscalar123;
        assign outscalar_vld[123] = outscalar123_vld;
    end
    if(C_NUM_OUTSCALARS > 124) begin
        assign outscalar[124][C_OUTSCALAR_124_BITS-1:0] = outscalar124;
        assign outscalar_vld[124] = outscalar124_vld;
    end
    if(C_NUM_OUTSCALARS > 125) begin
        assign outscalar[125][C_OUTSCALAR_125_BITS-1:0] = outscalar125;
        assign outscalar_vld[125] = outscalar125_vld;
    end
    if(C_NUM_OUTSCALARS > 126) begin
        assign outscalar[126][C_OUTSCALAR_126_BITS-1:0] = outscalar126;
        assign outscalar_vld[126] = outscalar126_vld;
    end
    if(C_NUM_OUTSCALARS > 127) begin
        assign outscalar[127][C_OUTSCALAR_127_BITS-1:0] = outscalar127;
        assign outscalar_vld[127] = outscalar127_vld;
    end
endgenerate

//assign output data reg to port
assign scalar_dout = scalar_out_reg;

//generate input scalar registers
genvar idx;
generate
    for(idx=0; idx<C_NUM_INSCALARS; idx=idx+1) begin :INSCALAR_REG_GEN
        in_register #(
            .C_NUM_BITS(C_INSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx])
        ) inscalar_reg (
            .din(scalar_din),
            .we(inscalar_we[idx]),
            .clk(clk),
            .dout(inscalar_fifo[idx][C_INSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0]),
            .ready(inscalar_ready[idx])
        );

        fifo #(
            .WIDTH(C_INSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]),
            .DEPTH(C_FIFO_DEPTH)
        ) in_fifo_i (
            .wr_clk(clk),
            .din(inscalar_fifo[idx][C_INSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0]),
            .write(inscalar_ready[idx]),
            .full(inscalar_fifo_full[idx]),
            .dout(inscalar[idx][C_INSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0]),
            .read(inscalar_next[idx]),
            .empty(inscalar_fifo_empty[idx]),
            .rd_clk(acc_clk)
        );

        assign inscalar_we[idx] = scalar_we & (scalar_write_addr == idx);
    end
endgenerate

//generate output scalar registers
generate
    if(C_NUM_OUTSCALARS == 0) begin
        assign outscalar_fifo32[0] = 0;
        assign outscalar_fifo32[-1] = 0;

        assign outscalar_fifo_empty = 0;
        assign outscalar_fifo_full = 0;
        assign outscalar_null_empty = 0;
        assign outscalar_null_dout = 0;
    end

    for(idx=0; idx<C_NUM_OUTSCALARS; idx=idx+1) begin :OUTSCALAR_REG_GEN
        //generate valid latch
        always @(posedge acc_clk) begin
            if(outscalar_vld[idx]) begin
                outscalar_reg[idx][C_OUTSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0] <= outscalar[idx][C_OUTSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0];
                outscalar_found_vld[idx] <= 1;
            end
            if(capture_reg)
                outscalar_found_vld[idx] <= 0;
        end

        fifo #(
            .WIDTH(C_OUTSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]),
            .DEPTH(C_FIFO_DEPTH)
        ) out_fifo_i (
            .wr_clk(acc_clk),
            .din(outscalar_reg[idx][C_OUTSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0]),
            .write(capture_reg),
            .full(outscalar_fifo_full[idx]),
            .dout(outscalar_fifo[idx][C_OUTSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0]),
            .read(outscalar_read[idx]),
            .empty(outscalar_fifo_empty[idx]),
            .rd_clk(clk)
        );

        fifo #(
            .WIDTH(1),
            .DEPTH(C_FIFO_DEPTH)
        ) null_fifo_i (
            .wr_clk(acc_clk),
            .din(outscalar_found_vld[idx]),
            .write(capture_reg),
            //.full(outscalar_fifo_full[idx]),
            .dout(outscalar_null_dout[idx]),
            .read(outscalar_null_read[idx]),
            .empty(outscalar_null_empty[idx]),
            .rd_clk(clk) 
        );

        out_register #(
            .C_NUM_BITS(C_OUTSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx])
        ) outscalar_reg_i (
            .din(outscalar_fifo[idx][C_OUTSCALAR_BIT_ARRAY[32*(idx+1)-1:32*idx]-1:0]),
            .read(outscalar_read[idx]),
            .clk(clk),
            .re(outscalar_re[idx]),
            .dout(outscalar_fifo32[idx])
        );

        assign outscalar_re[idx] = scalar_re & (scalar_read_addr == (idx+C_MAX_INSCALARS));
    end
endgenerate

    //read interface
    always @* begin
        if(scalar_read_addr >= C_MAX_INSCALARS)
            scalar_out_reg <= outscalar_fifo32[scalar_read_addr-C_MAX_INSCALARS];
        else
            scalar_out_reg <= 32'h00C0FFEE;
    end

endmodule

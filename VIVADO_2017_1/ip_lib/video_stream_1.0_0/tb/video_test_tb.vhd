library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;
entity video_test_tb is
end video_test_tb;
-------------------------------------------------------------------------
architecture behavioral of video_test_tb is
    constant LINE_WIDTH      :  integer:=1079;
    constant LINE_HIGHT      :  integer:=4;
    signal FVAL              :  std_logic:='0';
    signal LVAL              :  std_logic:='0';
    signal cam_reset         :  std_logic:='0';
-------------------------------------------------------------------------
	constant revision_number : std_logic_vector(31 downto 0) := x"03202017";
	constant C_s_axis_video_test_TDATA_WIDTH   : integer     := 24;
	constant C_s_axis_video_test_START_COUNT   : integer     := 32;
	constant C_s_conf_video_test_DATA_WIDTH    : integer     := 32;
	constant C_s_conf_video_test_ADDR_WIDTH    : integer     := 4;
-------------------------------------------------------------------------
	type camlink_buffer_bus is record
		x_cnt       : integer range 0 to 640;
		y_cnt       : integer range 0 to 640;
		frame_high  : integer range 0 to 640;
		valid_high  : integer range 0 to 640;
		data        : integer range 0 to 640;
		datas       : integer range 0 to 4096;
		fvalid      : std_logic;
		lvalid      : std_logic;
	end record;
	signal video : camlink_buffer_bus;
-------------------------------------------------------------------------
component video_stream_v1_0 is
generic (
C_M00_AXIS_TDATA_WIDTH    : integer     := 24);
port (
pixclk          : in std_logic;
resetlow        : in std_logic;
ifval           : in std_logic;
ilval           : in std_logic;
idata           : in std_logic_vector(11 downto 0);
p_tdata         : out std_logic_vector(11 downto 0);
p_tvalid        : out std_logic;
m_axis_xcont    : out std_logic_vector(15 downto 0);
m_axis_ycont    : out std_logic_vector(15 downto 0);      
m00_axis_aclk     : in std_logic;
m00_axis_aresetn : in std_logic;
m00_axis_tuser      : out std_logic;
m00_axis_tkeep   : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
m00_axis_tvalid     : out std_logic;
m00_axis_tid     : out std_logic_vector(0 downto 0);
m00_axis_tdest     : out std_logic_vector(0 downto 0);
m00_axis_tdata     : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
m00_axis_tstrb     : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
m00_axis_tlast     : out std_logic;
m00_axis_tready     : in std_logic);
end component video_stream_v1_0;

-------------------------------------------------------------------------
    procedure clk_gen(signal clk : out std_logic; constant freq : real) is
    constant period    : time := 1 sec / freq;
    constant high_time : time := period / 2;
    constant low_time  : time := period - high_time;
    begin
        loop
            clk <= '1';
        wait for high_time;
            clk <= '0';
        wait for low_time;
    end loop;
    end procedure;
-------------------------------------------------------------------------
    signal pixclk                    :  std_logic;
    signal resetlow                  :  std_logic;
    signal ifval                     :  std_logic;
    signal ilval                     :  std_logic;
    signal idata                     :  std_logic_vector(11 downto 0);

    signal s_axis_video_test_aclk    :  std_logic;
    signal s_axis_video_test_aresetn :  std_logic;
    signal s_axis_video_test_tvalid  :  std_logic;
    signal s_axis_video_test_tdata   :  std_logic_vector(C_s_axis_video_test_TDATA_WIDTH-1 downto 0);
    signal s_axis_video_test_tstrb   :  std_logic_vector((C_s_axis_video_test_TDATA_WIDTH/8)-1 downto 0);
    signal s_axis_video_test_tlast   :  std_logic;
    signal s_axis_video_test_tready  :  std_logic;
    signal s_axis_video_tkeep        :  std_logic_vector((C_s_axis_video_test_TDATA_WIDTH/8)-1 downto 0);
    signal s_axis_video_tuser        :  std_logic;
    signal s_axis_video_tid          :  std_logic_vector(0 downto 0);
    signal s_axis_video_tdest        :  std_logic_vector(0 downto 0);

    signal p_tdata         :  std_logic_vector(11 downto 0);
    signal p_tvalid        :  std_logic;
    signal m_axis_xcont    :  std_logic_vector(15 downto 0);
    signal m_axis_ycont    :  std_logic_vector(15 downto 0);      
    
begin
-------------------------------------------------------------------------
	clk_gen(pixclk, 96.00e6);
	clk_gen(s_axis_video_test_aclk, 150.00e6);

------------------------------------------------------------------------- 
	process begin
		cam_reset       <= '0';

		resetlow        <= '0';
		s_axis_video_test_aresetn <= '0';

		wait for 100 ns;
		s_axis_video_test_aresetn <= '1';


		resetlow        <= '1';    
		wait for 200 ns;
		cam_reset       <= '1';
		wait for 200 ns;
		wait;
	end process;
-------------------------------------------------------------------------
	process (pixclk,cam_reset) begin
		if (cam_reset ='0') then 
			video.frame_high <= 0;
		elsif (rising_edge(pixclk) ) then
			if (video.valid_high = LINE_WIDTH + 40) then
				if (video.frame_high > LINE_HIGHT) then
					video.frame_high <= 0;
				else
					video.frame_high <= video.frame_high + 1;
				end if;
			end if;
		end if;
	end process;
------------------------------------------------------------------------- 
	process (pixclk,cam_reset) begin
		if (cam_reset ='0') then
			video.valid_high <= 0;
		elsif(rising_edge(pixclk) ) then
			if (video.valid_high > LINE_WIDTH + 40) then
				video.valid_high <= 1;
			else
				video.valid_high <= video.valid_high + 1;
			end if;
		end if;
	end process;
------------------------------------------------------------------------- 
	process (pixclk,cam_reset) begin
		if (cam_reset ='0') then
			video.data <= 0;
		elsif(rising_edge(pixclk) ) then
			if (video.data > LINE_WIDTH + 40) then
				video.data <= 1;
			else
				video.data <= video.data + 1;
			end if;
		end if;
	end process;
	process (pixclk,cam_reset) begin
        if (cam_reset ='0') then
            video.datas <= 1;
        elsif(rising_edge(pixclk) ) then
            if (video.data > 1081) then
                video.datas <= 9;
            else
                video.datas <= video.datas + 1;
            end if;
        end if;
    end process;	
------------------------------------------------------------------------- 
	video.fvalid <='1' when (video.frame_high < LINE_HIGHT and cam_reset ='1') else '0';
	video.lvalid <='1' when (video.valid_high < LINE_WIDTH and cam_reset ='1') else '0';
	idata       <= std_logic_vector(to_unsigned(video.datas, 12)) when (video.fvalid ='1' and video.lvalid ='1') else (others => '0');
-------------------------------------------------------------------------
video_stream_inst: video_stream_v1_0
generic map(
    C_M00_AXIS_TDATA_WIDTH => 24)
port map(
--***********************************************************************
    pixclk                    =>     pixclk,
    resetlow                  =>     resetlow,
    ifval                     =>     video.fvalid ,
    ilval                     =>     video.lvalid ,
    idata                     =>     idata ,
    p_tdata                   =>     p_tdata,
    p_tvalid                  =>     p_tvalid,
    m_axis_xcont              =>     m_axis_xcont,
    m_axis_ycont              =>     m_axis_ycont,	
--***********************************************************************
    m00_axis_aclk         =>     s_axis_video_test_aclk,
    m00_axis_aresetn      =>     s_axis_video_test_aresetn,
    m00_axis_tvalid       =>     s_axis_video_test_tvalid,
    m00_axis_tdata        =>     s_axis_video_test_tdata,
    m00_axis_tstrb        =>     s_axis_video_test_tstrb,
    m00_axis_tlast        =>     s_axis_video_test_tlast,
    m00_axis_tready       =>     s_axis_video_test_tready,
    m00_axis_tkeep        =>     s_axis_video_tkeep,
    m00_axis_tuser        =>     s_axis_video_tuser,
    m00_axis_tid          =>     s_axis_video_tid ,
    m00_axis_tdest        =>     s_axis_video_tdest);
-------------------------------------------------------------------------

end behavioral;
module uart_top(
	input 	sys_clk,	//ϵͳʱ��
	input 	sys_rst_n,	//ϵͳ��λ
 
	input 	uart_rxd,	//���ն˿�
	output 	uart_txd	//���Ͷ˿�

);
parameter	UART_BPS=921600;			//������
parameter	CLK_FREQ=50_000_000;	//ϵͳƵ��50M	

wire uart_en_w;
wire pixel_valid_out_w;
wire [7:0] uart_data_w;
wire [7:0] pixel_out_w;  
 
//��������ģ��
uart_tx#(
	.BPS		    (UART_BPS),
	.SYS_CLK_FRE	(CLK_FREQ))
u_uart_tx(
	.sys_clk		(sys_clk),
	.sys_rst_n	    (sys_rst_n),
	.uart_tx_en		(pixel_valid_out_w),
	.uart_data	    (pixel_out_w),	
	.uart_txd	    (uart_txd)
);
//ֱ��ͼ����ģ��
histogram_equalization #(
	.total_pixels   (921600))
u_histogram_equalization( 
    .clk            (sys_clk), 
    .rst_n          (sys_rst_n), 
    .pixel_in       (uart_data_w), 
    .pixel_valid_in (uart_en_w), 
    .pixel_out      (pixel_out_w), 
    .pixel_valid_out(pixel_valid_out_w)
); 
//��������ģ��
uart_rx #(
	.BPS				(UART_BPS),
	.SYS_CLK_FRE		(CLK_FREQ))
u_uart_rx(
	.sys_clk			(sys_clk),
	.sys_rst_n		    (sys_rst_n),
	
	.uart_rxd		    (uart_rxd),	
	.uart_rx_done	    (uart_en_w),
	.uart_rx_data	    (uart_data_w)
);
 
endmodule

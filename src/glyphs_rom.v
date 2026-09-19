`default_nettype none

module glyphs_rom(
	input  wire [5:0] c,   // phrase position 0-20
	input  wire [3:0] y,   // row 0-11
	input  wire [2:0] x,   // column 0-7
	output wire       pixel
);

	// Phrase position -> letter code
	// C O L E G I O _ D E _ M U N T I N L U P A
	function [3:0] letter;
		input [5:0] p;
		case (p)
			6'd0:  letter = 4'd0;   // C
			6'd1:  letter = 4'd1;   // O
			6'd2:  letter = 4'd2;   // L
			6'd3:  letter = 4'd3;   // E
			6'd4:  letter = 4'd4;   // G
			6'd5:  letter = 4'd5;   // I
			6'd6:  letter = 4'd1;   // O
			6'd7:  letter = 4'd15;  // space
			6'd8:  letter = 4'd6;   // D
			6'd9:  letter = 4'd3;   // E
			6'd10: letter = 4'd15;  // space
			6'd11: letter = 4'd7;   // M
			6'd12: letter = 4'd8;   // U
			6'd13: letter = 4'd9;   // N
			6'd14: letter = 4'd10;  // T
			6'd15: letter = 4'd5;   // I
			6'd16: letter = 4'd9;   // N
			6'd17: letter = 4'd2;   // L
			6'd18: letter = 4'd8;   // U
			6'd19: letter = 4'd11;  // P
			6'd20: letter = 4'd12;  // A
			default: letter = 4'd15;
		endcase
	endfunction

	// Letter code -> 5x7 bitmap (35 bits, row 0 in the top 5 bits)
	function [34:0] bitmap;
		input [3:0] l;
		case (l)
			4'd0:  bitmap = {5'b01110,5'b10001,5'b10000,5'b10000,5'b10000,5'b10001,5'b01110}; // C
			4'd1:  bitmap = {5'b01110,5'b10001,5'b10001,5'b10001,5'b10001,5'b10001,5'b01110}; // O
			4'd2:  bitmap = {5'b10000,5'b10000,5'b10000,5'b10000,5'b10000,5'b10000,5'b11111}; // L
			4'd3:  bitmap = {5'b11111,5'b10000,5'b10000,5'b11110,5'b10000,5'b10000,5'b11111}; // E
			4'd4:  bitmap = {5'b01110,5'b10001,5'b10000,5'b10111,5'b10001,5'b10001,5'b01111}; // G
			4'd5:  bitmap = {5'b01110,5'b00100,5'b00100,5'b00100,5'b00100,5'b00100,5'b01110}; // I
			4'd6:  bitmap = {5'b11110,5'b10001,5'b10001,5'b10001,5'b10001,5'b10001,5'b11110}; // D
			4'd7:  bitmap = {5'b10001,5'b11011,5'b10101,5'b10101,5'b10001,5'b10001,5'b10001}; // M
			4'd8:  bitmap = {5'b10001,5'b10001,5'b10001,5'b10001,5'b10001,5'b10001,5'b01110}; // U
			4'd9:  bitmap = {5'b10001,5'b11001,5'b10101,5'b10011,5'b10001,5'b10001,5'b10001}; // N
			4'd10: bitmap = {5'b11111,5'b00100,5'b00100,5'b00100,5'b00100,5'b00100,5'b00100}; // T
			4'd11: bitmap = {5'b11110,5'b10001,5'b10001,5'b11110,5'b10000,5'b10000,5'b10000}; // P
			4'd12: bitmap = {5'b01110,5'b10001,5'b10001,5'b11111,5'b10001,5'b10001,5'b10001}; // A
			default: bitmap = 35'd0;                                                          // blank
		endcase
	endfunction

	// Glyph occupies rows 2..8 and columns 1..5 of the 8x12 cell
	wire        in_rows = (y >= 4'd2) && (y <= 4'd8);
	wire        in_cols = (x >= 3'd1) && (x <= 3'd5);
	wire [2:0]  r       = y[2:0] - 3'd2;
	wire [5:0]  base    = 6'd34 - (r * 6'd5);
	wire [34:0] bm      = bitmap(letter(c));
	wire [4:0]  row     = bm[base -: 5];
	wire [2:0]  col     = 3'd5 - x;   // x=1 -> leftmost bit

	assign pixel = (c < 6'd21) & in_rows & in_cols & row[col];

endmodule
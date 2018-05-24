module Control(
	clk, rst_n, opcode,
	IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, Branch, PCWrite,
	ALUSrcB,ALUOp, PCSrc
   );
	input clk, rst_n;
	input [5:0] opcode;
	output reg IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, Branch, PCWrite;
	output reg [1:0] ALUSrcB, ALUOp, PCSrc;
	
	reg [3:0] cur_state, next_state;
	
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			cur_state <= 0;
		end else begin
			cur_state <= next_state;
		end
	end
	
	always@(*)
	begin
		case(cur_state)
			0:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			1:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=3;
				ALUOp=0;
				PCSrc=0;
			end
			2:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=0;
				PCWrite=0;
				ALUSrcB=2;
				ALUOp=0;
				PCSrc=0;
			end
			3:
			begin
				IorD=1;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			4:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=1;
				RegWrite=1;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			5:
			begin
				IorD=1;
				MemWrite=1;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			6:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=2;
				PCSrc=0;
			end
			7:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=1;
				MemtoReg=0;
				RegWrite=1;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			8:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=1;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=1;
				PCSrc=1;
			end
			9:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=1;
				Branch=0;
				PCWrite=0;
				ALUSrcB=2;
				ALUOp=0;
				PCSrc=0;
			end
			10:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=1;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
			11:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=1;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=2;
			end
			12:
			begin // wait mem
				IorD=0;
				MemWrite=0;
				IRWrite=1;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=1;
				ALUSrcB=1;
				ALUOp=0;
				PCSrc=0;
			end
			default:
			begin
				IorD=0;
				MemWrite=0;
				IRWrite=0;
				RegDst=0;
				MemtoReg=0;
				RegWrite=0;
				ALUSrcA=0;
				Branch=0;
				PCWrite=0;
				ALUSrcB=0;
				ALUOp=0;
				PCSrc=0;
			end
		endcase
	end

	parameter	OP_RTYPE = 6'h0;
	parameter	OP_ADDI = 6'h8;
	parameter	OP_LW   = 6'h23;
	parameter	OP_SW   = 6'h2b;
	parameter	OP_ADD  = 6'h0;
	parameter	OP_BGTZ = 6'h7;
	parameter	OP_J    = 6'h2;
	
	always@(*)
	begin
		case(cur_state)
			0: next_state = 12; //wait mem
			1:
			begin
				if(opcode == OP_LW || opcode == OP_SW) next_state = 2;
				else if(opcode == OP_RTYPE) next_state = 6;
				else if(opcode == OP_BGTZ) next_state = 8;
				else if(opcode == OP_ADDI) next_state = 9;
				else if(opcode == OP_J) next_state = 11;
				else next_state = 0;
			end
			2:
			begin
				if(opcode == OP_LW) next_state = 3;
				else next_state = 5;
			end
			3: next_state = 4;
			6: next_state = 7;
			9: next_state = 10;
			12: next_state = 1;
			default: next_state = 0;
		endcase
	end

endmodule
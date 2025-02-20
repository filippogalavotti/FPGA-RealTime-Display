// FILIPPO GALAVOTTI 0001031079

`timescale 1ns/1ps

module tb_plot_graph();

/////////////
// SEGNALI //
/////////////

logic clk_i;
logic rst_ni;
logic [1:0] plotcoord_i;
logic plotdata_i;
logic newdata_i;

logic video_sync_o;
logic video_data_o;
logic [1:0] current_column_o;


plot_graph DUT(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .plotcoord_i(plotcoord_i),
    .plotdata_i(plotdata_i),
    .newdata_i(newdata_i),

    .video_sync_o(video_sync_o),
    .video_data_o(video_data_o),
    .current_column_o(current_column_o)
);

//
// CLOCK GENERATION
//


always begin
	#5 clk_i = !clk_i;
end

initial begin

	// inizializzo i valori

	clk_i = 1'b1;
	rst_ni = 1'b1;
	plotcoord_i = 2'b00;
	plotdata_i = 1'b0;
	newdata_i = 1'b0;

	/////////////////////
	// RESET ASINCRONO //
	/////////////////////

	@(negedge clk_i)
	rst_ni = 1'b0;
	@(negedge clk_i)
	rst_ni = 1'b1;

	/////////////////
	// SIMULAZIONE //
	/////////////////

	// verifichiamo che la stampa all'avvio del sistema sia quella che ci aspettiamo;

	repeat (24) @ (negedge clk_i);

	// ricreiamo la situazione nel testo d'esame;

	repeat(2) @ (negedge clk_i);

	newdata_i = 1'b1;
	plotcoord_i = 1;
	plotdata_i = 1;

	@ (negedge clk_i);

	newdata_i = 1'b0;
	plotcoord_i = 0;
	plotdata_i = 0;
	
	repeat(2) @ (negedge clk_i);
	
	newdata_i = 1'b1;
	plotcoord_i = 2;
	plotdata_i = 1;

	@ (negedge clk_i);

	newdata_i = 1'b0;
	plotcoord_i = 0;
	plotdata_i = 0;

	repeat(2) @ (negedge clk_i);

	newdata_i = 1'b1;
	plotcoord_i = 1;
	plotdata_i = 1;

	@ (negedge clk_i);

	newdata_i = 1'b0;
	plotcoord_i = 0;
	plotdata_i = 0;

	repeat (24) @ (negedge clk_i);

	// supponiamo che arrivino due dati in cicli di clock adiacenti

	@(negedge clk_i);

	newdata_i = 1'b1;
	plotcoord_i = $urandom_range(0, 3);
	plotdata_i = $urandom_range(0, 1);

	@(negedge clk_i);

	newdata_i = 1'b1;
	plotcoord_i = $urandom_range(0, 3);
	plotdata_i = $urandom_range(0, 1);

	@(negedge clk_i);
	
	newdata_i = 1'b0;

	// testiamo varie configurazioni di input, in particolare non azzeriamo
	// plotcoord e plotdata per verificare la condizione di indifferenza a 
	// newdata = 0;

repeat (15) begin

	@(negedge clk_i);

	newdata_i = 1'b1;
	plotcoord_i = $urandom_range(0, 3);
	plotdata_i = $urandom_range(0, 1);

	@ (negedge clk_i);

	newdata_i = 1'b0;

	repeat($urandom_range(0, 63)) @ (negedge clk_i);
	
end
	$stop;
end

endmodule

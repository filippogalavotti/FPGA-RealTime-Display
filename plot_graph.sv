// FILIPPO GALAVOTTI 0001031079S

module plot_graph (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic [1:0] plotcoord_i,
    input  logic plotdata_i,
    input  logic newdata_i,

    output logic video_sync_o,
    output logic video_data_o,
    output logic [1:0] current_column_o
);


//////////////////////////////
// DESCRIZIONE DEL PROGETTO //
//////////////////////////////

// Il progetto si compone di una semplice logic che include due segnali adibiti
// a contatori: uno strumentale al tracking della colonna (column_counter),
// mentre l'altro essenziale alla generazione seriale del segnale 'video_data' (output_counter);

// NOTA BENE: ho deciso di separare la memorizzazione dei dati in ingresso dalla
// generazione delle forme d'onda, per cui la forma d'onda in uscita non viene
// aggiornata fino alla successiva occorrenza di 'video_sync_o'

/////////////////////
// SEGNALI INTERNI //
/////////////////////

logic [3:0] output_counter_d, output_counter_q;
logic [15:0] plot_buffer_d, plot_buffer_q; // isola il plotting a video dalla memorizzazione dei dati in ingresso
logic [1:0] column_counter_d, column_counter_q;
logic [15:0] video_buffer_d, video_buffer_q; // tiene traccia dei dati in ingresso 

/////////////////////////
// LOGICA COMBINATORIA //
/////////////////////////

assign current_column_o = column_counter_q;

always_comb begin

	// inizializzo i valori

	video_sync_o = 1'b0;
	video_data_o = 1'b0;

	output_counter_d = output_counter_q;
	plot_buffer_d = plot_buffer_q;
	column_counter_d = column_counter_q;
	video_buffer_d = video_buffer_q;

	// input data management

	if(newdata_i) begin
		video_buffer_d[4*(-plotcoord_i+3) + column_counter_q] = plotdata_i;
		column_counter_d = column_counter_q + 1;
	end

	// output data management

	output_counter_d = output_counter_q + 1;
	video_data_o = plot_buffer_q[output_counter_q];
	if(output_counter_q == 0) begin
		video_sync_o = 1'b1;
		plot_buffer_d = video_buffer_q;
	end
	
end

////////////////////////
// LOGICA SEQUENZIALE //
////////////////////////

always_ff @ (posedge clk_i or negedge rst_ni) begin
	
	if(!rst_ni) begin
		output_counter_q <= 4'b0000;
		plot_buffer_q <= 16'b0000_0000_0000_0000;
		column_counter_q <= 2'b00;
		video_buffer_q <= 16'b0000_0000_0000_0000;
	end else begin
		output_counter_q <= output_counter_d;
		plot_buffer_q <= plot_buffer_d;
		column_counter_q <= column_counter_d;
		video_buffer_q <= video_buffer_d;
	end
end
endmodule

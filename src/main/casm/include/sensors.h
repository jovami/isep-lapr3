#pragma once

/**
 * Gera o valor de temperatura com base no último valor de temperatura.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor aleatório (positivo ou negativo).
 *
 * A componente aleatória não deverá produzir variações drásticas à temperatura entre medições consecutivas.
 *
 * @param ult_temp Último valor de temperatura medido (°C)
 * @param comp_rand Componente aleatório para a geração do novo valor da temperatura
 *
 * @return A nova medição do valor da temperatura (°C)
 */
char sens_temp(char ult_temp, char comp_rand);


/**
 * Gera o valor de velocidade do vento com base no último valor de velocidade do vento.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * aleatório (positivo ou negativo).
 *
 * A componente aleatória pode produzir variações altas entre medições consecutivas, simulando assim o efeito
 * de rajadas de vento.
 *
 * @param ult_velc_vento Última velocidade do vento medida (km/h)
 * @param comp_rand Componente aleatório para a geração do novo valor da velocidade do vento
 *
 * @return O novo medição do valor da velocidade do vento (km/h)
 */
unsigned char sens_velc_vento(unsigned char ult_velc_vento, char comp_rand);


/**
 * Gera o valor de direção do vento com base no último valor de direção do vento.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * aleatório (positivo ou negativo).
 *
 * A direção do vento toma valores de 0 a 359, representam graus relativamente ao Norte.
 *
 * A direção do vento não deve variar de forma drástica entre medições consecutivas.
 *
 * @param ult_dir_vento Última direção do vento medida (graus)
 * @param comp_rand Componente aleatório para a geração do novo valor da direção do vento
 *
 * @return A nova medição do valor da direção do vento (graus)
 */
unsigned short sens_dir_vento(unsigned short ult_dir_vento, short comp_rand);


/**
 * Gera o valor de humidade atmosférica com base no último valor de humidade atmosférica.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * de modificação (positivo ou negativo).
 *
 * O valor de modificação terá uma componente aleatória e uma componente relativa ao último
 * valor de pluvisiodade registado, que contribuirá para uma maior ou menor alteração à
 * modificação.
 *
 * A menos que tenha chovido, o valor de modificação não deverá produzir variações drásticas à humidade
 * atmosférica entre medições consecutivas.
 *
 * @param ult_hmd_atm Última humidade atmosférica medida (percentagem)
 * @param ult_pluvio Último valor de pluviosidade medido (mm)
 * @param comp_rand Componente aleatório para a geração do novo valor da humidade atmosférica
 *
 * @return A nova medição do valor da humidade atmosférica (percentagem)
 */
unsigned char sens_humd_atm(unsigned char ult_hmd_atm, unsigned char ult_pluvio, char comp_rand);


/**
 * Gera o valor de humidade do solo com base no último valor de humidade do solo.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * de modificação (positivo ou negativo).
 *
 * O valor de modificação terá uma componente aleatória e uma componente relativa ao último
 * valor de pluvisiodade registado, que contribuirá para uma maior ou menor alteração à
 * modificação.
 *
 * A menos que tenha chovido, o valor de modificação não deverá produzir variações drásticas à humidade do
 * solo entre medições consecutivas.
 *
 * @param ult_hmd_solo Última humidade do solo medida (percentagem)
 * @param ult_pluvio Último valor de pluviosidade medido (mm)
 * @param comp_rand Componente aleatório para a geração do novo valor da humidade do solo
 *
 * @return A nova medição do valor da humidade do solo (percentagem)
 */
unsigned char sens_humd_solo(unsigned char ult_hmd_solo, unsigned char ult_pluvio, char comp_rand);


/**
 * Gera o valor de pluviosidade com base no último valor de pluviosidade.
 * O novo valor a gerar será o incremento ao último valor gerado, adicionado de um valor
 * de modificação (positivo ou negativo).
 *
 * O valor de modificação terá uma componente aleatória e uma componente relativa à última
 * temperatura registada, que contribuirá para uma maior ou menor alteração à modificação.
 *
 * Assim produz-se o efeito de, com temperaturas altas ser menos provável que chova, e com
 * temperaturas mais baixas ser mais provável que chova.
 *
 * Quando a pluviosidade anterior for nula, se o valor de modificação for negativo a
 * pluviosidade deverá permanecer nula.
 *
 * @param ult_pluvio Último valor de pluviosidade medido (mm)
 * @param ult_temp Último valor de temperatura medido (°C)
 * @param comp_rand Componente aleatório para a geração do novo valor de pluviosidade
 *
 * @return A nova medição do valor de pluviosidade (mm)
 */
unsigned char sens_pluvio(unsigned char ult_pluvio, char ult_temp, char comp_rand);



/*
 * Verifica se o valor gerado não irá implicar uma mudança drástica
 * no ultimo valor gerado.
 *
 * @param value_ref valor de referencia
 * @param generated valor gerado
 * @param delta valor que determina qual sera um delta para um determinado valor gerado
 *      ser considerado uma mudançã drástica
 * */
char verify_value_generated(unsigned short value_ref, short generated, unsigned char delta);



int gen_sens_values(char *data_temp,unsigned short *data_dir_vento, unsigned char *data_velc_vento,
                        unsigned char *data_humd_atm, unsigned char *data_humd_solo, unsigned char *data_pluvio);

//ALL
#define FREQUENCY 2
#define INITIAL_BAD_VALUES 0
#define TIMER 2
#define CICLES 15
#define MAX_BAD_VALUES 10

//TEMP
#define TEMP_LIM_MAX 50
#define TEMP_LIM_MIN -30

//PLUVIO
#define PLUVIO_LIM_MAX 150
#define PLUVIO_LIM_MIN 0

//DIR_VENTO
#define DIR_VENTO_LIM_MAX 359
#define DIR_VENTO_LIM_MIN 0

//VELC_VENTO
#define VELC_VENTO_LIM_MAX 90
#define VELC_VENTO_LIM_MIN 0

//HUMD_SOLO
#define HUMD_SOLO_LIM_MAX 100
#define HUMD_SOLO_LIM_MIN 0

//HUMD_ATM
#define HUMD_ATM_LIM_MAX 65
#define HUMD_ATM_LIM_MIN 0


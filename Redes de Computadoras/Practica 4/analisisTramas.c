#include <stdio.h>
#include <string.h>
#define MAX 500

/*
	En este programa los bits se trabajan de forma invertida: MSB...LSB -> LSB...MSB
*/

// MARTES 25 MZO: TRAMA 1 INDICA SI ES O NO MODO EXTENDIDO, en caso de SNRME | SABME | SARME then activar una bandera

int modoExtendido = 0;

enum wwdenS
{
	rrS = 0, rejS = 2, rnrS = 1, srejS = 3,
};
enum wwdenU
{
	snrmO = 16, snrmeO = 27, sarmO = 3, sarmeO = 11, sabmO = 7, sabmeO = 15, uiO = 0, discO = 8, simO = 1, upO = 4, rsetO = 19, xidO = 23,
};
enum RespuestaU
{
	dmR = 3, uiR = 0, uaR = 12, rdR = 8, rimR = 1, xidR = 23, frmrR = 17,
};

int checkTamTipo(const unsigned char *tr) // Se comporta distinto si no se considera del tipo 'unsigned'
{
	if((tr[12]*256)+tr[13] < 1500)
		return 1;
	else
		return 0;
}

unsigned int getEthernetType(const unsigned char *tr)
{
	unsigned int d, x[2];
	x[0] = (unsigned int) tr[12];
	x[1] = (unsigned int) tr[13];
	return d = (x[0]<<8) | x[1];
}

char checkTipoTrama(const unsigned char *tr) // Saber si la trama es de Informacion, Supervision o Unsigned (HDLC)
{
	/*
	Analizando con bits volteados:
		Informacion: [nr][nr][nr][p/f][ns][ns][ns][0]
		Supervision: [nr][nr][nr][p/f][s][s][0][1]
		Unnumbered: [m][m][m][p/f][m][m][1][1]

		Hacer dos comparaciones a la vez
	    a7 a6 a5 a4 a3 a2 a1 a0
      &  0  0  0  0  0  0  1  1
      ___________________________
         0  0  0  0  0  0 a1 a0

	    a1 a0 == 00 -> Informacion
	    a1 a0 == 10 -> Informacion
	    a1 a0 == 01 -> Supervision
	    a1 a0 == 11 -> Unnumbered
    */

	switch(tr[16] & 3)
	{
		case 0:
			return 'I';
			break;
		case 1:
			return 'S';
			break;
		case 2:
			return 'I';
			break;
		case 3:
			return 'U';
			break;
	}
}

void getwwdenRespuestaTramaU(const unsigned char pF, unsigned char campoControl, char *ordenwwRespuesta)
{
	// Juntar bits [MM MMM] campo control... --> MMPMMM 101010 --> MM = 10 --> MMM = 010

	unsigned char or = (campoControl >> 3) & 28, tmp = (campoControl >> 2) & 3, mmmmm = or | tmp;

	if(pF == 0)
	{
		enum wwdenU ou;
		switch(mmmmm)
		{
			case snrmO:
				strcpy(ordenwwRespuesta, "SNRM");
				break;
			case snrmeO:
				strcpy(ordenwwRespuesta, "SNRME");
				modoExtendido = 1;
				break;
			case sarmO:
				strcpy(ordenwwRespuesta, "SARM");
				break;
			case sarmeO:
				strcpy(ordenwwRespuesta, "SARME");
				modoExtendido = 1;
				break;
			case sabmO:
				strcpy(ordenwwRespuesta, "SABM");
				break;
			case 15:
				strcpy(ordenwwRespuesta, "SABME");
				modoExtendido = 1;
				break;
			case uiO:
				strcpy(ordenwwRespuesta, "UI");
				break;
			case discO:
				strcpy(ordenwwRespuesta, "DISC");
				break;
			case simO:
				strcpy(ordenwwRespuesta, "SIM");
				break;
			case upO:
				strcpy(ordenwwRespuesta, "UP0");
				break;
			case rsetO:
				strcpy(ordenwwRespuesta, "RSET");
				break;
			case xidO:
				strcpy(ordenwwRespuesta, "XID");
				break;
			default:
				strcpy(ordenwwRespuesta, "---");
				break;
		}
	}
	else if(pF == 1)
	{
		enum RespuestaU ru;
		switch(mmmmm)
		{
			case dmR:
				strcpy(ordenwwRespuesta, "DM");
				break;
			case uiR:
				strcpy(ordenwwRespuesta, "UI");
				break;
			case uaR:
				strcpy(ordenwwRespuesta, "UA");
				break;
			case rdR:
				strcpy(ordenwwRespuesta, "RD");
				break;
			case rimR:
				strcpy(ordenwwRespuesta, "RIM");
				break;
			case xidR:
				strcpy(ordenwwRespuesta, "XID");
				break;
			case frmrR:
				strcpy(ordenwwRespuesta, "FRMR");
				break;
			default:
				strcpy(ordenwwRespuesta, "---");
				break;
		}
	}
}

void getwwdenTramaS(unsigned char campoControl, char *ordenwwRespuesta)
{
	enum wwdenS os;

	switch(campoControl & 12)
	{
		case rrS:
			strcpy(ordenwwRespuesta, "RR");
			break;
		case rejS:
			strcpy(ordenwwRespuesta, "REJ");
			break;
		case rnrS:
			strcpy(ordenwwRespuesta, "RNR");
			break;
		case srejS:
			strcpy(ordenwwRespuesta, "SREJ");
			break;
		default:
			strcpy(ordenwwRespuesta, "---");
			break;
	}
}

unsigned char voltearBits(unsigned char o)
{
	unsigned char orig = o, tmp1, final = 0, i;
	for(i = 7; i > 0; i--)
	{
		tmp1 = orig & 1;
		tmp1 <<= i;
		final = tmp1 | final;
		orig >>= 1;
	}
	return final;
}

unsigned char getNr(unsigned int tam, const unsigned char *tr)
{
	if(tam < 4)
		return voltearBits(tr[16]) & 7;
	else
		return voltearBits(tr[17]) & 127;
}

unsigned char getNs(unsigned int tam, const unsigned char *tr)
{
	if(tam < 4)
		return voltearBits(tr[16]) & 112;
	else
		return voltearBits(tr[17]) & 127;
}

int main(void)
{
	unsigned char trama[MAX], z, hex[3];
	unsigned int eth, flag = 0, sync = 0, pos = 0, j;
	FILE *arch = fopen("tramas", "r"), *salida = fopen("analisisTramas", "w");
	
	if(arch == NULL || salida == NULL)
	{
		perror("Error [Archivo]");
		return -1;
	}

	hex[2] = '\0';

	while(feof(arch) == 0)
	{
		z = (char) fgetc(arch);

		if(z != ' ')
		{
			if(z == '\n')
			{
				if(flag == 1)
				{
					unsigned char pfBit = trama[15] & 1;
					unsigned int tamanio = (trama[12] << 8) | trama[13];

					fprintf(salida, "MAC destino:\t");
					for(j = 0; j < 6; j++)
					{
						fprintf(salida, "%02X", trama[j]);
						if(j < 5)
							fprintf(salida, ":");
					}
					fprintf(salida, "\n");

					fprintf(salida, "MAC origen:\t");
					for(j = 6; j < 12; j++)
					{
						fprintf(salida, "%02X", trama[j]);
						if(j < 11)
							fprintf(salida, ":");
					}
					fprintf(salida, "\n");

					if(checkTamTipo(trama))
					{
						char tipoTrama = checkTipoTrama(trama), ordenwwRespuesta[6];

						fprintf(salida, "Trama:\t\tIEEE 802.3\n");
						fprintf(salida, "Tamanio:\t%d bytes\n", tamanio);

						if(tipoTrama == 'U')
						{
							getwwdenRespuestaTramaU(pfBit, trama[16], ordenwwRespuesta);
							fprintf(salida, "Tipo:\t\t%c - %s\n", tipoTrama, ordenwwRespuesta);
							memset(ordenwwRespuesta, '\0', strlen(ordenwwRespuesta)); // Limpiar la cadena
						}
						else if(tipoTrama == 'S')
						{
							fprintf(salida, "N(r): \t\t%u\n", getNr(tamanio, ordenwwRespuesta));
							getwwdenTramaS(trama[16], ordenwwRespuesta);
							fprintf(salida, "Tipo:\t\t%c - %s\n", tipoTrama, ordenwwRespuesta);
							memset(ordenwwRespuesta, '\0', strlen(ordenwwRespuesta));
						}
						else
						{
							fprintf(salida, "N(r): \t\t%u\n", getNr(tamanio, ordenwwRespuesta));
							fprintf(salida, "N(s): \t\t%u\n", getNs(tamanio, ordenwwRespuesta));
							fprintf(salida, "Tipo:\t\t%c\n", tipoTrama);
						}
					}
					else
					{
						eth = getEthernetType(trama);
						fprintf(salida, "Trama:\t\tEthernet\n");
						fprintf(salida, "Ethertype:\t0x%04X = %d ", eth, eth);
						if(eth == 2048)
							fprintf(salida, "(DOD IP)\n");
						else if(eth == 2054)
							fprintf(salida, "(ARP)\n");
					}
					if(pfBit == 0)
						fprintf(salida, "P/F:\t\t[P]\n");
					else if(pfBit == 1)
						fprintf(salida, "P/F:\t\t[F]\n");

					fprintf(salida, "\n");
					pos = 0;
				}
				else
					flag = 1;
			}
			else
			{
				if(sync == 0)
				{
					hex[sync] = z;
					sync = 1;
				}
				else
				{
					hex[sync] = z;
					sscanf(hex, "%2x", &trama[pos]);
					sync = 0;
					pos++;
				}
				flag = 0;
			}
		}
	}

	fprintf(salida, "ww wwnio ww - 2CM9 | ww.com\n");
	fclose(salida);
	fclose(arch);

	return 0;
}
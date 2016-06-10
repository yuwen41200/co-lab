/**
 * Please compile with C++11.
 * It's already 2016 now.
 */

#include <cmath>
#include <cstdio>

#define BYTE 1
#define KIBIBYTE (1024 * BYTE)

struct cache_content {
	bool valid;
	unsigned int tag;
};

double simulate(int cache_size, int block_size, char const *memory_trace) {
	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size / block_size);
	int cache_line = cache_size >> offset_bit;

	cache_content *cache = new cache_content[cache_line];
	// printf("cache_line = %02d\n", cache_line);

	for (int i = 0; i < cache_line; ++i)
		cache[i].valid = false;

	unsigned int address, hit = 0, miss = 0;
	FILE *fp = fopen(memory_trace, "r");

	while (fscanf(fp, "%x", &address) != EOF) {
		// printf("%#010x\t", address);
		unsigned int index = (address >> offset_bit) & (cache_line - 1);
		unsigned int tag = address >> (index_bit + offset_bit);

		if (cache[index].valid && cache[index].tag == tag)
			++hit; // printf(" hit = %02d\n", ++hit);

		else {
			cache[index].valid = true;
			cache[index].tag = tag;
			++miss; // printf("miss = %02d\n", ++miss);
		}
	}

	fclose(fp);
	delete [] cache;

	return (double) miss / (hit + miss) * 100;
}

int main() {
	char const *filename;
	double miss_rate;

	filename = "ICACHE.txt";
	for (int i = 64; i <= 512; i*=2) {
		for (int j = 4; j <= 32; j*=2) {
			miss_rate = simulate(i * BYTE, j * BYTE, filename);
			printf("cache_size = %03d bytes, ", i);
			printf("block_size = %02d bytes, ", j);
			printf("memory_trace = %s, ", filename);
			printf("miss_rate = %04.1f%%\n", miss_rate);
		}
	}

	filename = "DCACHE.txt";
	for (int i = 64; i <= 512; i*=2) {
		for (int j = 4; j <= 32; j*=2) {
			miss_rate = simulate(i * BYTE, j * BYTE, filename);
			printf("cache_size = %03d bytes, ", i);
			printf("block_size = %02d bytes, ", j);
			printf("memory_trace = %s, ", filename);
			printf("miss_rate = %04.1f%%\n", miss_rate);
		}
	}

	return 0;
}

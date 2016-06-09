/**
 * Please compile with C++11.
 * It's already 2016 now.
 */

#include <climits>
#include <cmath>
#include <cstdio>

#define BYTE 1
#define KIBIBYTE (1024 * BYTE)
#define WAY 1

struct cache_content {
	bool valid;
	unsigned int tag;
	unsigned int timestamp;
};

double simulate(int cache_size, int block_size, int associativity, char *memory_trace) {
	cache_size /= associativity;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size / block_size);
	int cache_line = cache_size >> offset_bit;

	cache_content **cache = new cache_content*[cache_line];
	printf("cache_line = %02d\n", cache_line);

	for (int i = 0; i < cache_line; ++i) {
		cache[i] = new cache_content[associativity];
		for (int j = 0; j < associativity; ++j) {
			cache[i][j].valid = false;
			cache[i][j].timestamp = 0;
		}
	}

	unsigned int address, hit = 0, miss = 0;
	FILE *fp = fopen(memory_trace, "r");

	while (fscanf(fp, "%x", &address) != EOF) {
		printf("%#010X\t", address);
		unsigned int index = (address >> offset_bit) & (cache_line - 1);
		unsigned int tag = address >> (index_bit + offset_bit);

		bool is_hit = false;
		unsigned int min_timestamp = UINT_MAX;
		int min_timestamp_at = -1;

		for (auto const &element : cache[index]) {
			if (element.valid && element.tag == tag) {
				printf("hit = %02d\n", ++hit);
				element.timestamp = hit + miss;
				is_hit = true;
				break;
			}
		}

		if (!is_hit) {
			for (int i = 0; i < associativity; ++i) {
				if (cache[index][i].timestamp < min_timestamp) {
					min_timestamp = cache[index][i].timestamp;
					min_timestamp_at = i;
				}
			}

			printf("miss = %02d\n", ++miss);
			cache[index][min_timestamp_at].timestamp = hit + miss;
			cache[index][min_timestamp_at].valid = true;
			cache[index][min_timestamp_at].tag = tag;
		}
	}

	for (int i = 0; i < cache_line; ++i) {
		delete [] cache[i];
	}

	fclose(fp);
	delete [] cache;

	return miss / (hit + miss) * 100;
}

int size(int cache_size, int block_size, int associativity) {
	cache_size /= associativity;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size / block_size);
	int cache_line = cache_size >> offset_bit;

	int element_size = (32 - index_bit - offset_bit) + 1 + block_size;
	return cache_line * associativity * element_size;
}

int main() {
	char *filename;
	double miss_rate;
	int total_size;

	filename = "LU.txt";
	for (int i = 1; i <= 32; i*=2) {
		for (int j = 1; j <= 8; j*=2) {
			miss_rate = simulate(i * KIBIBYTE, 64 * BYTE, j * WAY, filename);
			printf("cache_size = %02d kibibytes, ", i);
			printf("associativity = %1d ways, ", j);
			printf("memory_trace = %s, ", filename);
			printf("miss_rate = %04.1f%%\n", miss_rate);
		}
	}

	filename = "RADIX.txt";
	for (int i = 1; i <= 32; i*=2) {
		for (int j = 1; j <= 8; j*=2) {
			miss_rate = simulate(i * KIBIBYTE, 64 * BYTE, j * WAY, filename);
			printf("cache_size = %02d kibibytes, ", i);
			printf("associativity = %1d ways, ", j);
			printf("memory_trace = %s, ", filename);
			printf("miss_rate = %04.1f%%\n", miss_rate);
		}
	}

	for (int i = 1; i <= 32; i*=2) {
		for (int j = 1; j <= 8; j*=2) {
			total_size = size(i * KIBIBYTE, 64 * BYTE, j * WAY);
			printf("cache_size = %02d kibibytes, ", i);
			printf("associativity = %1d ways, ", j);
			printf("total_size = %08d bits\n", total_size * 8);
		}
	}

	return 0;
}

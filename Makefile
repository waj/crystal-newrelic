all: newrelic

newrelic: $(shell find src -name '*.cr')
	crystal build -o $@ src/newrelic.cr

clean:
	rm -f newrelic


lexlib=l
yacclib=y
bindir=.
rm=/bin/rm -f
mv=/bin/mv -f
targets=simple-expr simple-varexpr decaf-ast
cpptargets=usingcpp

all: $(targets) $(cpptargets)

$(targets): %: %.y
	@echo "compiling yacc file:" $<
	@echo "output file:" $@
	bison --debug -o$@.tab.c -d $< -v
	flex -o$@.lex.c $@.lex
	gcc -o $(bindir)/$@ $@.tab.c $@.lex.c -l$(yacclib) -l$(lexlib) -lm
	$(rm) $@.tab.c $@.tab.h $@.lex.c

$(cpptargets): %: %.y
	@echo "compiling cpp yacc file:" $<
	@echo "output file:" $@
	bison --debug -b $@ -d $< -v
	$(mv) $@.tab.c $@.tab.cc
	flex -o$@.lex.cc $@.lex
	g++ -o $(bindir)/$@ $@.tab.cc $@.lex.cc -l$(yacclib) -l$(lexlib)
	$(rm) $@.tab.h $@.tab.cc $@.lex.cc

test: $(targets) $(cpptargets)
	@echo "testing simple-expr ..."
	echo "12" | $(bindir)/simple-expr
	echo "a=2+3+5" | $(bindir)/simple-expr
	echo "(a (b c) d)" | $(bindir)/usingcpp

clean:
	$(rm) $(targets) $(cpptargets)
	$(rm) *.tab.h *.tab.c *.lex.c
	$(rm) *.pyc

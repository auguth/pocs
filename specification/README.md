# Proof of Contract Stake (PoCS) Specification

**PoCS specification pdf** -> [pocs-spec.pdf](specification/pocs-spec.pdf) 

**PoCS specification Latex source** -> [pocs-spec.tex](specification/pocs-spec.tex)

## Installing LaTeX

Choose the installation method based on your operating system:

**Ubuntu/Linux**
```bash
sudo apt update
sudo apt install texlive-full
```
**macOS (via MacTeX):**

- Download and install from [MacTeX](https://tug.org/mactex/mactex-download.html).

**Windows (via MiKTeX):**

- Download and install from [MiKTeX](https://miktex.org/download).


## Building the specification

Ensure you are in the directory where pocs-spec.tex is located:

```bash
cd /specification/
```

Compile the pocs-spec.tex file to a PDF:

```bash
pdflatex pocs-spec.tex
```

Open the generated pocs-spec.pdf:

```bash
xdg-open pocs-spec.pdf
```
(Use open on macOS or start on Windows.)


## Clean Build Files
To remove auxiliary files (.aux, .log, etc.), run
``` bash
rm *.aux *.log *.out *.toc

```


## License

This pocs-spec is licensed under the MIT License.
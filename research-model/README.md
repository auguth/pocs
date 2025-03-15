# Proof of Contract Stake (PoCS) Research Model

**PoCS research pdf** -> [pocs-research.pdf](research-model/pocs-research.pdf) 

**PoCS research Latex source** -> [pocs-research.tex](research-model/pocs-research.tex)

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


## Building the research-model

Ensure you are in the directory where pocs-research.tex is located:

```bash
cd /research-model/
```

Compile the pocs-research.tex file to a PDF:

```bash
pdflatex pocs-research.tex
```

Open the generated pocs-research.pdf:

```bash
xdg-open pocs-research.pdf
```
(Use open on macOS or start on Windows.)


## Clean Build Files
To remove auxiliary files (.aux, .log, etc.), run
``` bash
rm *.aux *.log *.out *.toc

```


## License

This pocs-research is licensed under the MIT License.
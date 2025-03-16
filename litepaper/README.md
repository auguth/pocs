# Proof of Contract Stake (PoCS) Litepaper

**Litepaper pdf** -> [pocs-litepaper.pdf](litepaper/pocs-litepaper.pdf) 

**Litepaper Latex source** -> [pocs-litepaper.tex](litepaper/pocs-litepaper.tex)

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


## Building the Litepaper

Ensure you are in the directory where pocs-litepaper.tex is located:

```bash
cd /litepaper
```

Compile the pocs-litepaper.tex file to a PDF:

```bash
pdflatex pocs-litepaper.tex
```

Open the generated pocs-litepaper.pdf:

```bash
xdg-open pocs-litepaper.pdf
```
(Use open on macOS or start on Windows.)


## Clean Build Files
To remove auxiliary files (.aux, .log, etc.), run
``` bash
rm *.aux *.log *.out *.toc

```


## License

This pocs-litepaper is licensed under the MIT License.
# Import packages
from urllib.request import urlretrieve
import pandas as pd
import re
import time
from tkinter import *
from tkinter import filedialog
from pandastable import Table, TableModel


# Assign url of file: url
url = 'http://www.ibama.gov.br/phocadownload/sinaflor/2022/2022-07-22_Lista_especies_DOF.csv'

# Read file into a DataFrame
sistaxon = pd.read_csv(url, encoding='latin1')


def pop_name():
    """Search in SISTAXON's data by popular name"""

    # remove typos
    n = name.get().lower().capitalize()
        
    # Set a pandas data frame to output
    global output
    output = pd.DataFrame(sistaxon.query(f'`Nome popular` == @n'))
    output = output[['Nome cientifico', 'Nome popular']]
    #print('\nForam encontradas', str(len(output)),  f'espécies associadas ao nome popular {n}')
              
    if output.empty:
        print('Nome não consta no SISTAXON.')
    else:
        f = Frame(main_window)
        f.grid(column=0, row=16, pady=5)
        table = pt = Table(f, dataframe=output, showtoolbar=False, showstatusbar=True)
        pt.show()

        save_button = Button(main_window, text='Salvar CSV', command=save_file)
        save_button.grid(column=0, row=17)

def genus():
    """Search in SISTAXON's data by genus"""

    # get the genus name and remove typos
    n = name.get().lower().capitalize()
        
    # Set a pandas data frame to output
    global output
    output = pd.DataFrame(sistaxon[sistaxon['Nome cientifico'].str.contains(fr'{n}', regex=True)])
    output = output[['Nome cientifico', 'Nome popular']]
    #print('\nForam encontradas', str(len(output)),  f'espécies associadas ao gênero {n}')

    if output.empty:
        print('Gênero não consta no SISTAXON.')
    else:
        f = Frame(main_window)
        f.grid(column=0, row=16, pady=5)
        table = pt = Table(f, dataframe=output, showtoolbar=False, showstatusbar=True)
        pt.show()

        save_button = Button(main_window, text='Salvar CSV', command=save_file)
        save_button.grid(column=0, row=17)


def sp():
    """Search in SISTAXON's data by scientific name"""

    # get the scientific name
    n = name.get().lower().capitalize()

    # Set a pandas data frame to output
    global output
    output = pd.DataFrame(sistaxon.query('`Nome cientifico` == @n'))
    output = output[['Nome cientifico', 'Nome popular']]

    if output.empty:
         print('Espécie não consta no SISTAXON.')
    else:
        f = Frame(main_window)
        f.grid(column=0, row=16, pady=5)
        table = pt = Table(f, dataframe=output, showtoolbar=False, showstatusbar=True)
        pt.show()

        save_button = Button(main_window, text='Salvar CSV', command=save_file)
        save_button.grid(column=0, row=17)


def save_file():
    """Save a data frame as .csv file"""

    file = filedialog.asksaveasfilename(
        filetypes=[('csv file', '.csv')],
        defaultextension='.csv'
    )
    if file:
        output.to_csv(file, index=False, sep=';')  # store as CSV file
        l3 = Label(my_w, text=file + ' Saved')
        l3.grid(row=5, column=1)


# Build GUI #
main_window = Tk()

main_window.title('Busca Espécie SISTAXON')
main_window.geometry('1280x960')

text_position = Label(main_window, text='Digite o nome popular/gênero/espécie\n\n'
                                        'Para buscar por Nome Popular (ex.: Cedro, Angelim-de-folha-larga)\n'
                                        'Para buscar por Gênero (ex.: Cedrela)\n'
                                        'Para buscar por Espécie (ex.: Cedrela odorata)\n')
text_position.grid(column=0, row=2)
name = Entry(main_window)
name.place(width=800, height=80)
name.grid(column=0, row=4)

text_cmd = Label(main_window, text='Click na opção desejada')
text_cmd.grid(column=0, row=6, padx=2, pady=10)

# Search by popular name
button = Button(main_window, text='Buscar Pelo nome Popular', command=pop_name)
button.grid(column=0, row=8)

# Search by genus
button = Button(main_window, text='Buscar pelo Gênero', command=genus)
button.grid(column=0, row=10, pady=5)

# Search by specie
button = Button(main_window, text='Buscar pela Espécie', command=sp)
button.grid(column=0, row=12)

main_window.mainloop()

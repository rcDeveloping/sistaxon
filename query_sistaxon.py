# Import packages
from urllib.request import urlretrieve
import pandas as pd
import re
import time
from tkinter import *
from tkinter import filedialog
from pandastable import Table, TableModel
from tkinter.messagebox import showinfo
import logging


logging.basicConfig(
    level=logging.INFO, filename='log.log', format='%(asctime)s - %(levelname)s - %(message)s - %(funcName)s'
)


# Assign url of file: url
url = 'http://www.ibama.gov.br/phocadownload/sinaflor/2022/2022-07-22_Lista_especies_DOF.csv'

# Read file into a DataFrame
sistaxon = pd.read_csv(url, encoding='latin1')


def pop_name():
    """Search in SISTAXON's data by popular name"""

    # remove typos
    n = name.get().lower().capitalize()
    logging.info(n)

    # Set a pandas data frame to output
    global output
    output = pd.DataFrame(sistaxon.query(f'`Nome popular` == @n'))
    output = output[['Nome cientifico', 'Nome popular']]

    if output.empty:
        txt_out = 'Nome não consta no SISTAXON.'
        txt_output['text'] = txt_out
        logging.warning(n)

    else:
        txt_out = f'''Foram encontradas {str(len(output))} espécies associadas ao nome popular {n}'''
        txt_output['text'] = txt_out

        f = Frame(main_window)
        f.grid(column=1, row=9, pady='2px')
        table = Table(f, dataframe=output, showtoolbar=False, showstatusbar=True)
        table.show()

        save_button = Button(main_window, text='Salvar CSV', command=save_file)
        save_button.grid(column=1, row=10)


def genus():
    """Search in SISTAXON's data by genus"""

    # get the genus name and remove typos
    n = name.get().lower().capitalize()
    logging.info(n)

    # Set a pandas data frame to output
    global output
    output = pd.DataFrame(sistaxon[sistaxon['Nome cientifico'].str.contains(fr'{n}', regex=True)])
    output = output[['Nome cientifico', 'Nome popular']]

    if output.empty:
        txt_out = 'Gênero não consta no SISTAXON.'
        txt_output['text'] = txt_out
        logging.warning(n)

    else:
        txt_out = f'''Foram encontradas {str(len(output))} espécies associadas ao gênero {n}'''
        txt_output['text'] = txt_out

        f = Frame(main_window)
        f.grid(column=1, row=9, pady='2px')
        table = Table(f, dataframe=output, showtoolbar=False, showstatusbar=True)
        table.show()

        save_button = Button(main_window, text='Salvar CSV', command=save_file)
        save_button.grid(column=1, row=10)


def sp():
    """Search in SISTAXON's data by scientific name"""

    # get the scientific name
    n = name.get().lower().capitalize()
    logging.info(n)

    # Set a pandas data frame to output
    global output
    output = pd.DataFrame(sistaxon.query('`Nome cientifico` == @n'))
    output = output[['Nome cientifico', 'Nome popular']]

    if output.empty:
         txt_out = 'Espécie não consta no SISTAXON.'
         txt_output['text'] = txt_out
         logging.warning(n)

    else:
        txt_out = f'''Foram encontradas {str(len(output))} espécies associadas ao gênero {n}'''
        txt_output['text'] = txt_out

        f = Frame(main_window)
        f.grid(column=1, row=9, pady='2px')
        table = Table(f, dataframe=output, showtoolbar=False, showstatusbar=True)
        table.show()

        save_button = Button(main_window, text='Salvar CSV', command=save_file)
        save_button.grid(column=1, row=10)


def save_file():
    """Save a data frame as .csv file"""

    file = filedialog.asksaveasfilename(
        filetypes=[('csv file', '.csv')],
        defaultextension='.csv'
    )
    if file:
        output.to_csv(file, index=False, sep=';')  # store as CSV file
        # show_info(
        #     title='Arquivo Salvo!',
        #     message=file
        # )


# Build GUI #
main_window = Tk()

# Change the icon
#main_window.iconbitmap('./icon.ico')

main_window.title('Busca Espécie SISTAXON')
canvas = Canvas(main_window, width=1152, height=864)
canvas.grid(columnspan=3, rowspan=10)

text_position = Label(main_window, text='Para buscar por Nome Popular (ex.: Cedro, Angelim-de-folha-larga)\n'
                                        'Para buscar por Gênero (ex.: Cedrela)\n'
                                        'Para buscar por Espécie (ex.: Cedrela odorata)\n',
                      font=14)
text_position.grid(column=1, row=0)

name = Entry(main_window, width=50)
name.place(width=8, height=8)
name.grid(columnspan=3, column=0, row=1)

text_cmd = Label(main_window, text='Click na opção desejada')
text_cmd.grid(column=1, rowspan=2, row=2)

# Search by popular name
button = Button(main_window, text='Buscar Pelo nome Popular', font=13, command=pop_name)
button.grid(column=1, rowspan=2, row=3, ipady='0.5px', pady=5)

# Search by genus
button = Button(main_window, text='Buscar pelo Gênero', font=13, command=genus)
button.grid(column=1, rowspan=2, row=4, ipady='0.5px', pady=5)

# Search by specie
button = Button(main_window, text='Buscar pela Espécie', font=13, command=sp)
button.grid(column=1, rowspan=2, row=5, ipady='0.5px', pady=5)

txt_output = Label(main_window, text='', font=18, fg='#f00')
txt_output.grid(column=1, row=8)

main_window.mainloop()

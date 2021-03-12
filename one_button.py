from tkinter import *

tkWindow = Tk()
tkWindow.geometry('250x40')
tkWindow.title('One Button')


def toggleText():
    if (button['text'] == 'SUNIL'):
        button['text'] = 'SAGAR'
    else:
        button['text'] = 'SUNIL'


button = Button(tkWindow,
                text='SAGAR',
                command=toggleText)
button.pack()

tkWindow.mainloop()

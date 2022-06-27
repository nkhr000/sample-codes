import os
import csv
 
 
def split(filehandler, delimiter, output_dir, row_limit=200000, keep_headers=True):
    """
        Function split the file on row 
    """
 
    reader = csv.reader(filehandler, delimiter=delimiter)

    #Variable declartion:
    output_name_template='output_%s.csv'   
 
    current_piece = 1
    current_out_path = os.path.join(
        output_dir,
        output_name_template % current_piece
    )
    current_out_writer = csv.writer(open(current_out_path, 'w'), delimiter=delimiter)
    current_limit = row_limit

    if keep_headers:
        headers = next(reader)
        current_out_writer.writerow(headers)
    for i, row in enumerate(reader):
        if i + 1 > current_limit:
            current_piece += 1
            current_limit = row_limit * current_piece
            current_out_path = os.path.join(
                output_dir,
                output_name_template % current_piece
            )
            current_out_writer = csv.writer(open(current_out_path, 'w'), delimiter=delimiter)
            if keep_headers:
                current_out_writer.writerow(headers)
        current_out_writer.writerow(row)
 
 
if __name__ == "__main__":
    filename = r"C:\Users\INPUT.csv"
    output_dir = r'C:\Users\temp' 
    delimiter=','
    row_limit = 200000

    split(open(filename), delimiter, output_dir, row_limit)

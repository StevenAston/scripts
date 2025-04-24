# USE AT YOUR OWN RISK!
# Process bzfileids.dat and remove any files that aren't found
# Always shut down backblaze and all services when running this script
# Two files will be created, bzfileids.found.dat and bzfileids.lost.dat
# When complete you can manually replace bzfileids.dat with bzfileids.found.dat (and rename it)
# That should decrease your memory footprint

import os
import shutil

def clear_line():
	"""Clear the current terminal line"""
	print('\r' + ' ' * os.get_terminal_size().columns, end='\r')

def process_bzfileids():
	input_file = r'C:\ProgramData\Backblaze\bzdata\bzbackup\bzfileids.dat'
	backup_file = input_file + '.bak'
	found_file = r'C:\ProgramData\Backblaze\bzdata\bzbackup\bzfileids.found.dat'
	lost_file = r'C:\ProgramData\Backblaze\bzdata\bzbackup\bzfileids.lost.dat'

	# Create backup
	try:
		clear_line()
		print(f"Creating backup: {backup_file}...", end='\r')
		shutil.copy2(input_file, backup_file)
		clear_line()	
		print("✓ Backup created successfully")
	except Exception as e:
		clear_line()
		print(f"✗ Failed to create backup: {str(e)}")
		return

	try:
		# First pass to count total lines
		clear_line()
		print("Counting total lines...", end='\r')
		with open(input_file, 'r', encoding='utf-8', errors='replace') as f:
			total_lines = sum(1 for _ in f)
			f.seek(0)

			# Second pass to process files
			clear_line()
			print(f"Processing {total_lines:,} files...\n")
			
			with open(found_file, 'w', encoding='utf-8') as found, \
				 open(lost_file, 'w', encoding='utf-8') as lost:

				processed = 0
				for line in f:
					processed += 1
					try:
						parts = line.split('\t', 1)
						if len(parts) != 2:
							clear_line()
							print(f"! Malformed line: {line[:50]}...")
							continue

						_, path_part = parts
						file_path = path_part.rstrip('\r\n')
						exists = os.path.exists(file_path)
						
						if exists:
							found.write(line)
							status = "✓"
						else:
							lost.write(line)
							status = "✗"

						if processed % 128 == 0:
							# Clear and print progress
							clear_line()
							print(f"{status} [{processed:,}/{total_lines:,}] {file_path[:80]}...", end='\r')
					
					except Exception as e:
						clear_line()
						print(f"\n! Error processing line {processed}: {str(e)}")
						continue

		clear_line()
		print(f"✓ Processing complete! {total_lines:,} files processed")

	except UnicodeDecodeError as e:
		clear_line()
		print(f"\n✗ Fatal encoding error: {str(e)}")
		print("Try specifying a different encoding like 'latin-1' or 'utf-16'")
		raise

if __name__ == '__main__':
	process_bzfileids()

import "pe"

private rule pyinstaller_3x_strings
{
	strings:
		$s00 = "Error loading Python DLL '%s'."
		$s01 = "Cannot open self %s or archive %s"
		$s02 = "Cannot open PyInstaller archive from executable (%s) or external archive (%s)"
		$s10 = /PyInstalle(m|r): FormatMessageW failed\./
		$s11 = /PyInstalle(m|r): pyi_win32_utils_to_utf8 failed\./
	condition:
		pe.number_of_sections > 0 and
		any of ($s0*) and
		all of ($s1*)
}

private rule pyinstaller_3x_overlay
{
	strings:
		$s01 = { 4D 45 49 0C 0B 0A 0B 0E }      // PyInstaller magic number
		$s02 = /PYZ\-\d\d\.pyz/
		$s03 = /python3\d{1,2}\.dll/
	condition:
		pe.overlay.offset > 0 and
		@s02 > pe.overlay.offset and
		@s03 > pe.overlay.offset and
		all of them
}

rule pyinstaller_3x
{
	meta:
		tool = "I"
		name = "PyInstaller"
		version = "3.x"
		strength = "high"
	condition:
		pyinstaller_3x_strings and
		pyinstaller_3x_overlay
}

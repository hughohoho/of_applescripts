--
-- OmniFocus SmartPerspective
--
-- Will check for items in Inbox > Due (Forecast) > Flagged > Available > Someday
--

on run
	open_perspective()
end run

on open_perspective()
	tell application "OmniFocus"
		tell default document

			-- Inbox
			if (count (every inbox task)) > 0 then
				my conditions("Inbox")
				return
			end if

			-- Due > Forecast
			set currDate to (current date) - (time of (current date)) + (24 * hours - 1)
			set nDue to count (every available task of every flattened context whose due date is not greater than currDate)
			if (nDue) > 0 then
				my conditions("Forecast")
				return
			end if

			-- Flagged
			set nFlagged to count (every available task of every flattened context whose flagged is true)
			if (nFlagged) > 0 then
				my conditions("Flagged")
				return
			end if

			-- Available
			set nTotalAvailable to count (every available task of every flattened context)
			if (nTotalAvailable) > 0 then
				my conditions("Available")
				return
			end if

			-- Someday/Maybe tasks
			my conditions("Someday")

		end tell
	end tell
end open_perspective

-- Perspectives
on conditions(perName)
	tell application "OmniFocus"
		tell default document
			if visible of front document window is true then
				set perspective name of document window 1 to perName
			else
				make new document window with properties {perspective name:perName} at end of document windows
				activate
			end if
		end tell
	end tell
end conditions

-- For debugging | Usage: my notify("Label", variable)
on notify(theTitle, theDescription)
	display notification theDescription with title theTitle
end notify


---
title: "Example: pins usage and deployment"
author: "Katie Masiello"
date: "2020-05-11"
output:
  html_document:
    toc: true
    toc_float: true
    keep_md: true
---



# Purpose
This document provides a follow-along example of:  

* Creating a pin on RStudio Connect 
* Retrieving a pin from RStudio Connect 
* Publishing content that uses a pin to RStudio Connect  

# Notes 
This was built using `pins` version 0.4.0 and is supplemental material to the RStudio Customer Success Pro Tip: Creating Efficient Workflows with `pins` at https://colorado.rstudio.com/rsc/ProTips-pins/. 

# Prework
Prior to beginning, ensure you have  

1. Created an API key from RStudio Connect (see: https://docs.rstudio.com/connect/user/api-keys/)  
1. Saved your API key into your system environment variables with `Sys.setenv("RSC_API_KEY" = “key value”)`.  Important: Keep your keys secure! Set your system environment variable using the Console; not as something saved in your script! 

# Creating a pin
Let's say we are running an important analysis that involves body temperature mesurements of beavers. Let's look at our data first.  

```r
library(datasets)
head(beaver1)
```

```
##   day time  temp activ
## 1 346  840 36.33     0
## 2 346  850 36.34     0
## 3 346  900 36.35     0
## 4 346  910 36.42     0
## 5 346  920 36.55     0
## 6 346  930 36.69     0
```
Nice looking data!

Now we want to pin this data to RStudio Connect so it is also accessible to our colleagues for their important work and we don't have to email this around as a csv file.  Let's get started!

First, **register the board** so your session knows that it can place content on your Connect board:

```r
pins::board_register(
    "rsconnect", 
    server = "https://colorado.rstudio.com/rsc", # <- replace this with your server name 
    key = Sys.getenv("RSC_API_KEY")
    )
```
  
  
After running the script above, did you see that the Connections pane in your RStudio IDE now shows the board `rsconnect`?  This gives you an easy way to browse your organization's pinned objects.  Here's what mine looks like:  
  
<img src="connections_pane.png" width="65%" />
   
Now we want to **pin our data** to Connect. 

```r
pins::pin(beaver1, name="mybeavers-test", description = "Beaver Body Temperature Measurements", board = "rsconnect")
```
  
   
Take a moment to switch to Connect and give yourself a pat on the back.  **Your data is now pinned on Connect!**
<img src="pinned_to_connect.png" width="100%" />
  
From this window in Connect, you can adjust the user access permissions, add collaborators, and even give your pin a custom URL (see mine at https://colorado.rstudio.com/rsc/beaver-data/)  
<img src="pin_access_controls_and_vanityURL.png" width="30%" />
  
  
# Retrieving a pin  
Now let's pretend you're a colleague and you want to access this data for your own analysis.  

Feel free to put on a hat if it helps you to get into character.  At a minimum, you should restart your R session by either going to Session > Restart R, or pressing Shift+Cmd+F10 on your keyboard so we can start from a clean slate.
  
Now let's get the dataset from RStudio Connect. 

In Connect, did you notice the header information on your pin?  This is present on every pin published to Connect and it provides the code to retrieve your pin in either R or Python.  Handy, huh?  

<img src="retrieval_code.png" width="100%" />
  
   
So let's copy that code into our analysis and **retrieve the pin**.  

```r
# Register RStudio Connect
library(pins)
board_register("rsconnect", server = "https://colorado.rstudio.com/rsc",
    key = Sys.getenv("RSC_API_KEY"))

# Retrieve Pin
beaver_data <- pin_get("katie/beaver1", board = "rsconnect")
```
   
Now if you're paying close attention, you'll see that I also added in the argument for `key` in the `board_register()` function in my code above  If you're strictly calling pinned data for use locally, this isn't necessary.  However, if you're going to deploy your code to Connect (like I am with this document), you'll need to include your API key information so Connect knows who you are.  We'll talk more about this in a moment.  For now, let's get back to those beavers.

```r
#Check out the pin
head(beaver_data)
```

```
## # A tibble: 6 x 4
##     day  time  temp activ
##   <dbl> <dbl> <dbl> <dbl>
## 1   346   840  36.3     0
## 2   346   850  36.3     0
## 3   346   900  36.4     0
## 4   346   910  36.4     0
## 5   346   920  36.6     0
## 6   346   930  36.7     0
```
  
Jackpot!  We have our data.

# Publishing content that uses a pin 
So you think you're hot stuff and off and running?  For now, perhaps.  But let's say you want to publish something to Connect (like this RMD file), which uses pinned content in it.  Go ahead, try **publishing this document to your Connect instance** right now. 

Did you just get a ugly, angry, red error message?  
<img src="deployment_error.png" width="80%" />


Stop cursing! This is one time that an error message is good.  You've done it all right so far! Your error message might look a little different from mine, depending on what version of Connect you have, but the issue is the same.  This error is telling us that Connect can't find an API key.  *"API keys again? I thought this was a `pins` lesson, not an API key lesson!"*  Yes, so as alluded to in the previous section, we used our API key in our RStudio IDE session so that Connect could authenticate you acting through the IDE.  But this time Connect needs to authenticate you acting as a piece of content on Connect asking for access to another piece of content.   

Jump over to Connect and open your sad, un-rendered content.  
<img src="sad_unrendered_content.png" width="100%" />
  
Now in the right hand side pane, select the Environment Variables option and **input your API key as an environment variable.**  
<img src="set_env_variable.png" width="20%" />
  
Don't forget to click "Save" and then refresh your browser.  Hold breath... and... 

<img src="success.png" width="100%" />
  

Voilà!  Congratulations!  You're a pinning machine. **You've now deployed content that includes references to a pinned object.**

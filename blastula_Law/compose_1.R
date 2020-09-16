library(blastula)
library(ggplot2)
library(keyring) # Needed for create_smtp_creds_key()

# First just build a message
owl1 <- compose_email(body = "Hello from Hogwarts")

# Second, customize a message with a plot, footer, formatting... can set and also get these b/c in a script
viz <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), color="blue") + 
  theme_minimal() + xlab("Year at Hogwarts") + ylab("# of Wands Broken")

owl2 <- compose_email(
  body=md( c("Hello from Hogwarts, <br><br> First years, _PLEASE_ remember to bring more wands! [this link](www.rstudio.com)",
            add_ggplot(viz) ) ),
  footer="Confidential: the Ministry of Magic"
)
owl2 <- add_attachment(email=owl2, file = "./test_attach.csv") # have to assign back in. Argh! Let's add an example in

# Third, actually send our message via smtp, using gmail here.
# Note will need to turn on "less secure apps" in gmail by going here: https://myaccount.google.com/u/1/security
create_smtp_creds_file( # Note, requires library(keyring)
  file = "gmail_creds",
  user = "rbrianlaw@gmail.com",
  provider = "gmail",
  use_ssl = FALSE
) # Note, a pop up will ask for the pwd for the user you provided

# And let's make this smart about conditions
who_to <- if (2 < 3) "brian.law@rstudio.com" else "hadleey@rstudio.com"
which_owl <- if (2 < 3) owl2 else owl1

which_owl %>%
  smtp_send(
    to = who_to,
    from = "rbrianlaw@gmail.com",
    subject = "Testing automating emails, v1",
    credentials = creds_file("gmail_creds")
  )

# FAQs, can you build, attach and suppress in .Rmd but w/out RSC? Yes, yes, yes, see compose_2.Rmd.

# Remember that .rmd is a wrapper for some .R script.
# above is a .R file and sent w/out .rmd b/c can use smtp_send(), which allows to specficy subject, body, etc...
# if wanted to could wrap that script inside a .rmd and use it like above (see compose_2.R), OR
# If have RSC then get: enterprise auth, logs, easy scheduling,

# Within RSC could just use the compose_email() or ALSO have 
# the rmarkdown::output-metadata$set(rsc_...) stuff which allows you build a message but also to control attachments, suppress sending, or
# Note that there are sugar fxns for each of these 3 things in RSC as well: build, suppress, attach https://blog.rstudio.com/2019/12/05/emails-from-r-blastula-0-3/


# Dive into RSC
# use case for using send_smtp from INSIDE RSC is very odd and potentially not want to encourage b/c circumenting Named User counts.
# So focuses on the RSC specific stuff in our docs mostly: https://docs.rstudio.com/connect/user/r-markdown.html#r-markdown-email-customization
# , which are these sugar fxns are needed or not? not. output tag needed or not? yes. thru an example
# The selling point wiht RSC is NOT the fxnality we saw above, we already have that, it's the RSC specific stuff so use hello wrld and focus on that in RSC.

# actually the sugar function to render an email in RSC is annoying b/c requires you to create a separate .Rmd that is the email messgae, then call that message in a 2nd .Rmd doc where assembling the message.
# ^ makes using the sugar fxns not really worth it to me b/c more to manage now. 
# Plus the RSC docs don't show the sugar fxns so unclear how to learn about them beyond Sean's post and his example scripts.
# so use just the simple hello from hogwarts, and show off: sharing, scheduling, logs

# So, if not RSC, then use compose_email() to build the msg. If RSC, then use either compose_email() or output-metadata$set
# Then, if not RSC, send message via smtp_send(). if RSC then change output: to blastula email to send? No. that is only needed if spreading across emails.



# Hah! this worked, throws error in RSP tho?
# ---
#   title: "Title, Testing rmd sans RSC"
# output: html_document
# ---
#   
#   ```{r echo=FALSE}
# library(blastula)
# owl1 <- compose_email(body = "Hello from Hogwarts")
# 
# owl1 %>%
#   smtp_send(
#     to = "brian.law@rstudio.com",
#     from = "rbrianlaw@gmail.com",
#     subject = "Testing automating emails, v1",
#     credentials = creds_file("gmail_creds")
#   )
# 
# ```
#  when run ^ with otuput: blastula::blastula_email then gives sames result. But if remove library(blastula) from body fails, so the output thing is not loading library. Unclear to me what hte blastula::blastula_email does actually
# what does the output: blastula:: thing actually do? Only for RSC I think. [ask]

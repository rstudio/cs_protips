library(blastula)
library(ggplot2)

# First just build a message
owl1 <- compose_email(body = "Hello from Hogwarts")

# Second, customize a message with a plot, footer, formatting... can set and also get these b/c in a script
viz <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), color="maroon") + 
  theme_minimal() + xlab("Year at Hogwarts") + ylab("# of Wands Broken")

owl2 <- compose_email(
  body=md( c(
    "Hello from Hogwarts, <br><br> First years, _PLEASE_ remember to bring more wands!
    <br> [Olivander's Wand Shop](www.rstudio.com)",
      add_ggplot(viz) ) ),
  footer="Confidential: the Ministry of Magic"
)
owl2 <- add_attachment(email=owl2, file = "./test_attach.csv") # Note how have to assign back to the original object

# Third, actually send our message via smtp, using gmail here.
# Note will need to turn on "less secure apps" in gmail by going here: https://myaccount.google.com/u/1/security, which will turn itself off without warning you after a few weeks, then re-do it.
create_smtp_creds_file(
  file = "gmail_creds",
  user = "rbrianlaw@gmail.com",
  provider = "gmail",
  use_ssl = FALSE
) # Note, a pop up will ask for the password for the user you provided

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
